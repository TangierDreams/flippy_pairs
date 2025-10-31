import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_supabase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class SrvImagenes {
  static final supabaseImagenes = Supabase.instance.client;
  static late Directory directorioBase;
  static bool guardarVersionImagenes = true;

  // Mapa que contendrá todas las imagenes: 'animales/01.png' -> File
  static Map<String, File> todasLasImagenes = {};

  static final List<String> carpetasDeImagenes = [
    'flippy/animales',
    'flippy/coches',
    'flippy/logos',
    'flippy/retratos',
    'flippy/iconos',
    'flippy/herramientas',
  ];

  //----------------------------------------------------------------------------
  // Al inicializar nos bajamos las imagenes al dispositivo local
  //----------------------------------------------------------------------------

  static Future<void> inicializar() async {
    // Obtenemos la carpeta donde vamos a almacenar las imagenes:

    final appDir = await getApplicationDocumentsDirectory();
    directorioBase = Directory('${appDir.path}/flippy_images');
    if (!await directorioBase.exists()) {
      await directorioBase.create(recursive: true);
    }

    int versionLocal = SrvDiskette.leerValor(DisketteKey.versionImagenes, defaultValue: 0);
    int versionSupabase = int.parse(await SrvSupabase.getParam("flippy_images_version", pDefaultValue: "0"));

    // Descargamos las imagenes de cada carpeta de supbase a la carpeta local:

    if (versionLocal == versionSupabase && await _estanTodasLasImagenes()) {
      await _cargarImagenesDesdeLocal();
    } else {
      await _cargarImagenesDesdeSupabase(versionSupabase);
    }
  }

  //----------------------------------------------------------------------------
  // Comprobamos si existen todas la imagenes en local.
  //----------------------------------------------------------------------------

  static Future<bool> _estanTodasLasImagenes() async {
    for (String carpeta in carpetasDeImagenes) {
      final carpetaLocal = Directory('${directorioBase.path}/$carpeta');
      if (!await carpetaLocal.exists()) {
        SrvLogger.grabarLog('srv_imagenes', '_estanTodasLasImagenes()', 'Faltan carpetas en local');
        return false;
      }
      final numImagenes = carpetaLocal.listSync().where((item) => item.path.endsWith('.png')).length;

      if (numImagenes != 36) {
        SrvLogger.grabarLog('srv_imagenes', '_estanTodasLasImagenes()', 'Faltan imagenes en local');
        return false;
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
    SrvLogger.grabarLog('srv_imagenes', '_cargarImagenesDesdeLocal()', 'Finaliza la carga de imagenes desde local');
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
    }

    SrvLogger.grabarLog(
      'srv_imagenes',
      '_cargarImagenesDesdeSupabase()',
      'Finaliza la carga de imagenes desde Supabase',
    );
  }

  //----------------------------------------------------------------------------
  // Descargamos las imagenes de una de las carpetas de Supabase
  // Realizamos descargas de imagenes en paralelo para agilizar el proceso.
  //----------------------------------------------------------------------------

  static Future<void> _descargarCarpeta(String folderPath) async {
    final localFolder = Directory('${directorioBase.path}/$folderPath');
    if (!await localFolder.exists()) {
      await localFolder.create(recursive: true);
    }

    // Crear todas las tareas de descarga
    List<Future<void>> downloadTasks = [];

    for (int i = 1; i <= 36; i++) {
      final imageName = '${i.toString().padLeft(2, '0')}.png';
      downloadTasks.add(_descargarUnaImagen(folderPath, imageName));
    }

    // Descargar todas en paralelo (máximo 10 a la vez)
    await Future.wait(downloadTasks, eagerError: false);
  }

  //----------------------------------------------------------------------------
  // Descargar una sola imagen desde Supabase
  //----------------------------------------------------------------------------

  static Future<void> _descargarUnaImagen(String pCarpeta, String pNombreImagen) async {
    final localFile = File('${directorioBase.path}/$pCarpeta/$pNombreImagen');

    try {
      // Obtener la URL pública de Supabase
      final supabasePath = '$pCarpeta/$pNombreImagen';
      final imageUrl = supabaseImagenes.storage.from('others').getPublicUrl(supabasePath);

      // Descargar la imagen
      final response = await http.get(Uri.parse(imageUrl)).timeout(Duration(seconds: 2));

      if (response.statusCode == 200) {
        // Guardar en local (sobrescribe si ya existe)
        await localFile.writeAsBytes(response.bodyBytes);

        // Guardar en el mapa con clave: 'animales/01.png'
        final key = '$pCarpeta/$pNombreImagen';
        todasLasImagenes[key] = localFile;
      } else {
        guardarVersionImagenes = false;
        SrvLogger.grabarLog(
          'srv_imagenes',
          '_descargarUnaImagen()',
          'Error HTTP ${response.statusCode}: $pCarpeta/$pNombreImagen',
        );
      }
    } on TimeoutException {
      guardarVersionImagenes = false;
      SrvLogger.grabarLog('srv_imagenes', '_descargarUnaImagen()', 'Error Timeout: $pCarpeta/$pNombreImagen');
    } catch (e) {
      guardarVersionImagenes = false;
      SrvLogger.grabarLog('srv_imagenes', '_descargarUnaImagen()', 'Error descargando $pCarpeta/$pNombreImagen: $e');
    }
  }

  //----------------------------------------------------------------------------
  // Obtener una imagen por carpeta y nombre
  //----------------------------------------------------------------------------

  static File obtenerUnaImagen(String pCarpeta, String pImagen) {
    final key = 'flippy/$pCarpeta/$pImagen';
    return todasLasImagenes[key]!;
  }

  //----------------------------------------------------------------------------
  // Limpiar todas las imágenes descargadas
  //----------------------------------------------------------------------------

  static Future<void> clearCache() async {
    if (await directorioBase.exists()) {
      await directorioBase.delete(recursive: true);
      todasLasImagenes.clear();
    }
  }

  //----------------------------------------------------------------------------
  // Devolvemos una lista con los archivos de imagenes de una carpeta
  //----------------------------------------------------------------------------

  static List<File> _imagenesDeUnaCarpeta(String pCarpeta) {
    List<File> listaImagenes = [];
    for (var entry in todasLasImagenes.entries) {
      if (entry.key.contains('flippy/$pCarpeta/')) {
        listaImagenes.add(entry.value);
      }
    }
    return listaImagenes;
  }

  //----------------------------------------------------------------------------
  // Obtenemos un conjunto de imagenes para el juego.
  //----------------------------------------------------------------------------

  static List<File> obtenerImagenesParaJugar(int pNumParejas) {
    final random = Random();
    const int totalCartas = 36;

    // Empezamos a coger cartas desde un punto aleatorio:

    int startIndex = 0;
    if (pNumParejas < totalCartas) {
      int maxStartIndex = totalCartas - pNumParejas;
      startIndex = random.nextInt(maxStartIndex + 1);
    }

    // Obtenemos todas las url's de la lista seleccionada:

    List<File> listaBase;
    try {
      listaBase = _imagenesDeUnaCarpeta(InfoJuego.listaSeleccionada);
    } catch (e) {
      return [];
    }

    // A partir de la lista base, cogemos solo el número de imagenes que necesitamos:

    List<File> seleccionados = listaBase.sublist(startIndex, startIndex + pNumParejas).toList();

    // Los duplicamos para formasr las parejas:

    final duplicados = [...seleccionados, ...seleccionados];

    // Los desordenamos:

    duplicados.shuffle(random);
    return duplicados;
  }
}
