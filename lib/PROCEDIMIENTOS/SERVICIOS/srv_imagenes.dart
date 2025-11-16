import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_supabase.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class SrvImagenes {
  static final supabaseImagenes = Supabase.instance.client;
  static late Directory directorioBase;
  static bool guardarVersionImagenes = true;
  static Map<String, File> todasLasImagenes = {};

  // Optimized configuration for small images
  static const int _maxConcurrentDownloads = 8;
  static const int _downloadTimeoutSeconds = 5;
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(milliseconds: 300);

  static final List<String> carpetasDeImagenes = ['retratos', 'iconos', 'logos', 'coches', 'herramientas', 'animales'];

  static final List<String> _imagenesFallidas = [];
  static final _semaphore = Semaphore(_maxConcurrentDownloads);

  //----------------------------------------------------------------------------
  // Al inicializar nos bajamos las imagenes al dispositivo local
  //----------------------------------------------------------------------------

  static Future<void> inicializar() async {
    SrvLogger.grabarLog('srv_imagenes', 'inicializar()', 'Iniciando servicio de imágenes');

    // Obtenemos la carpeta donde vamos a almacenar las imagenes:
    final appDir = await getApplicationDocumentsDirectory();
    directorioBase = Directory('${appDir.path}/flippy_images');
    if (!await directorioBase.exists()) {
      await directorioBase.create(recursive: true);
    }

    int versionLocal = SrvDiskette.leerValor(DisketteKey.versionImagenes, defaultValue: 0);
    int versionSupabase = int.parse(await SrvSupabase.getParam("flippy_images_version", pDefaultValue: "0"));

    SrvLogger.grabarLog(
      'srv_imagenes',
      'inicializar()',
      'Versión local: $versionLocal, Versión Supabase: $versionSupabase',
    );

    // Descargamos las imagenes de cada carpeta de supbase a la carpeta local:
    //versionLocal
    if (versionLocal == versionSupabase && await _estanTodasLasImagenes()) {
      SrvLogger.grabarLog('srv_imagenes', 'inicializar()', 'Cargando imágenes desde cache local');
      await _cargarImagenesDesdeLocal();
    } else {
      SrvLogger.grabarLog('srv_imagenes', 'inicializar()', 'Descargando imágenes desde Supabase');
      await _cargarImagenesDesdeSupabase(versionSupabase);
    }

    SrvLogger.grabarLog('srv_imagenes', 'inicializar()', 'Servicio de imágenes inicializado correctamente');
  }

  //----------------------------------------------------------------------------
  // Comprobamos si existen todas la imagenes en local.
  //----------------------------------------------------------------------------

  static Future<bool> _estanTodasLasImagenes() async {
    for (String carpeta in carpetasDeImagenes) {
      final carpetaLocal = Directory('${directorioBase.path}/$carpeta');
      if (!await carpetaLocal.exists()) {
        SrvLogger.grabarLog(
          'srv_imagenes',
          '_estanTodasLasImagenes()',
          'Falta la carpeta local: ${directorioBase.path}/$carpeta',
        );
        return false;
      }
      final numImagenes = carpetaLocal.listSync().where((item) => item.path.endsWith('.png')).length;

      if (numImagenes != 36) {
        SrvLogger.grabarLog(
          'srv_imagenes',
          '_estanTodasLasImagenes()',
          'Faltan imagenes en local: ${directorioBase.path}/$carpeta ($numImagenes de 36)',
        );
        return false;
      } else {
        SrvLogger.grabarLog(
          'srv_imagenes',
          '_estanTodasLasImagenes()',
          'Carpeta local: ${directorioBase.path}/$carpeta ($numImagenes de 36)',
        );
      }
    }

    return true;
  }

  //----------------------------------------------------------------------------
  // Cargamos las imagenes desde el dispositivo local
  //----------------------------------------------------------------------------

  static Future<void> _cargarImagenesDesdeLocal() async {
    SrvLogger.grabarLog('srv_imagenes', '_cargarImagenesDesdeLocal()', 'Comienza la carga de imagenes desde local');
    for (String folder in carpetasDeImagenes) {
      final localFolder = Directory('${directorioBase.path}/$folder');

      for (int i = 1; i <= 36; i++) {
        final imageName = '${i.toString().padLeft(2, '0')}.png';
        final localFile = File('${localFolder.path}/$imageName');

        if (await localFile.exists()) {
          final key = '$folder/$imageName';
          todasLasImagenes[key] = localFile;
        }
      }
    }
    SrvLogger.grabarLog(
      'srv_imagenes',
      '_cargarImagenesDesdeLocal()',
      'Finaliza la carga de imagenes desde local. Total: ${todasLasImagenes.length} imágenes',
    );
  }

  //----------------------------------------------------------------------------
  // Cargamos las imagenes desde el Storage de Supabase
  //----------------------------------------------------------------------------

  static Future<void> _cargarImagenesDesdeSupabase(int pVersionSupabase) async {
    SrvLogger.grabarLog(
      'srv_imagenes',
      '_cargarImagenesDesdeSupabase()',
      'Comienza la carga de imagenes desde Supabase',
    );

    for (String carpeta in carpetasDeImagenes) {
      await _descargarCarpeta(carpeta);
    }

    if (guardarVersionImagenes) {
      SrvDiskette.guardarValor(DisketteKey.versionImagenes, pVersionSupabase);
      SrvLogger.grabarLog(
        'srv_imagenes',
        '_cargarImagenesDesdeSupabase()',
        'Versión de imágenes guardada: $pVersionSupabase',
      );
    }

    SrvLogger.grabarLog(
      'srv_imagenes',
      '_cargarImagenesDesdeSupabase()',
      'Finaliza la carga de imagenes desde Supabase. Total: ${todasLasImagenes.length} imágenes',
    );
  }

  //----------------------------------------------------------------------------
  // Descargamos las imagenes de una de las carpetas de Supabase
  //----------------------------------------------------------------------------

  static Future<void> _descargarCarpeta(String folderPath) async {
    _imagenesFallidas.clear();

    final localFolder = Directory('${directorioBase.path}/$folderPath');
    if (!await localFolder.exists()) {
      await localFolder.create(recursive: true);
    }

    SrvLogger.grabarLog('srv_imagenes', '_descargarCarpeta()', 'Iniciando descarga de carpeta: $folderPath');

    final downloadTasks = <Future<void>>[];

    for (int i = 1; i <= 36; i++) {
      final imageName = '${i.toString().padLeft(2, '0')}.png';
      downloadTasks.add(_descargarUnaImagenConRetry(folderPath, imageName));
    }

    await Future.wait(downloadTasks, eagerError: false);

    if (_imagenesFallidas.isNotEmpty) {
      SrvLogger.grabarLog(
        'srv_imagenes',
        '_descargarCarpeta()',
        'Reintentando ${_imagenesFallidas.length} imágenes fallidas',
      );

      final retryTasks = <Future<void>>[];
      for (var imagen in _imagenesFallidas.toList()) {
        retryTasks.add(_descargarUnaImagenConRetry(folderPath, imagen, isRetry: true));
      }

      await Future.wait(retryTasks, eagerError: false);
    }

    if (_imagenesFallidas.isNotEmpty) {
      SrvLogger.grabarLog(
        'srv_imagenes',
        '_descargarCarpeta()',
        'Finalizado con ${_imagenesFallidas.length} imágenes fallidas persistentes en $folderPath',
      );
    } else {
      SrvLogger.grabarLog(
        'srv_imagenes',
        '_descargarCarpeta()',
        'Todas las imágenes descargadas exitosamente: $folderPath',
      );
    }
  }

  //----------------------------------------------------------------------------
  // Descargar con reintentos automáticos
  //----------------------------------------------------------------------------

  static Future<void> _descargarUnaImagenConRetry(String pCarpeta, String pNombreImagen, {bool isRetry = false}) async {
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        await _semaphore.acquire();
        await _descargarUnaImagen(pCarpeta, pNombreImagen);

        if (isRetry) {
          _imagenesFallidas.remove(pNombreImagen);
        }
        return;
      } catch (e) {
        if (attempt == _maxRetries) {
          if (!_imagenesFallidas.contains(pNombreImagen)) {
            _imagenesFallidas.add(pNombreImagen);
          }
          SrvLogger.grabarLog(
            'srv_imagenes',
            '_descargarUnaImagenConRetry()',
            'Falló después de $attempt intentos: $pCarpeta/$pNombreImagen',
          );
        } else {
          await Future.delayed(_retryDelay * attempt);
        }
      } finally {
        _semaphore.release();
      }
    }
  }

  //----------------------------------------------------------------------------
  // Descargar una sola imagen desde Supabase
  //----------------------------------------------------------------------------

  static Future<void> _descargarUnaImagen(String pCarpeta, String pNombreImagen) async {
    final localFile = File('${directorioBase.path}/$pCarpeta/$pNombreImagen');

    try {
      final supabasePath = '$pCarpeta/$pNombreImagen';
      final imageUrl = supabaseImagenes.storage.from('flippy').getPublicUrl(supabasePath);

      final response = await http.get(Uri.parse(imageUrl)).timeout(Duration(seconds: _downloadTimeoutSeconds));

      if (response.statusCode == 200) {
        if (response.bodyBytes.isEmpty) {
          throw HttpException('Respuesta vacía');
        }

        await localFile.writeAsBytes(response.bodyBytes);

        final key = '$pCarpeta/$pNombreImagen';
        todasLasImagenes[key] = localFile;
      } else {
        throw HttpException('HTTP ${response.statusCode}');
      }
    } on TimeoutException {
      throw TimeoutException('Timeout después de $_downloadTimeoutSeconds segundos');
    } catch (e) {
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Obtener una imagen por carpeta y nombre
  //----------------------------------------------------------------------------

  static File obtenerUnaImagen(String pCarpeta, String pImagen) {
    final key = '$pCarpeta/$pImagen';
    return todasLasImagenes[key]!;
  }

  //----------------------------------------------------------------------------
  // Limpiar todas las imágenes descargadas
  //----------------------------------------------------------------------------

  static Future<void> clearCache() async {
    if (await directorioBase.exists()) {
      await directorioBase.delete(recursive: true);
      todasLasImagenes.clear();
      SrvDiskette.guardarValor(DisketteKey.versionImagenes, 0);
    }
  }

  //----------------------------------------------------------------------------
  // Devolvemos una lista con los archivos de imagenes de una carpeta
  //----------------------------------------------------------------------------

  static List<File> _imagenesDeUnaCarpeta(String pCarpeta) {
    List<File> listaImagenes = [];
    for (var entry in todasLasImagenes.entries) {
      if (entry.key.contains('$pCarpeta/')) {
        listaImagenes.add(entry.value);
      }
    }
    return listaImagenes;
  }

  //----------------------------------------------------------------------------
  // Obtenemos un conjunto de imagenes para el juego.
  //----------------------------------------------------------------------------

  static List<File> obtenerImagenesParaJugar(int pNumParejas) {
    SrvLogger.grabarLog("srv_imagenes", "obtenerImagenesParaJugar()", "Obtener imagenes para las cartas...");
    final random = Random();
    const int totalCartas = 36;

    int startIndex = 0;
    if (pNumParejas < totalCartas) {
      int maxStartIndex = totalCartas - pNumParejas;
      startIndex = random.nextInt(maxStartIndex + 1);
    }

    List<File> listaBase;
    try {
      listaBase = _imagenesDeUnaCarpeta(EstadoDelJuego.nomTema);
    } catch (e) {
      return [];
    }

    debugPrint("listaBase: ${listaBase.length}");
    debugPrint("StartIndex: $startIndex");
    debugPrint("FinalIndex: ${startIndex + pNumParejas}");

    List<File> seleccionados = listaBase.sublist(startIndex, startIndex + pNumParejas).toList();
    final duplicados = [...seleccionados, ...seleccionados];
    duplicados.shuffle(random);
    SrvLogger.grabarLog("srv_imagenes", "obtenerImagenesParaJugar()", "Devolvemos la lista de cartas duplicadas");
    return duplicados;
  }
}

//----------------------------------------------------------------------------
// Semaphore para controlar descargas concurrentes
//----------------------------------------------------------------------------

class Semaphore {
  Semaphore(this._maxCapacity);

  final int _maxCapacity;
  final Queue<Completer<void>> _waiting = Queue<Completer<void>>();
  int _current = 0;

  Future<void> acquire() async {
    if (_current < _maxCapacity) {
      _current++;
      return;
    }

    final completer = Completer<void>();
    _waiting.add(completer);
    await completer.future;
  }

  void release() {
    _current--;

    if (_waiting.isNotEmpty && _current < _maxCapacity) {
      _current++;
      _waiting.removeFirst().complete();
    }
  }
}
