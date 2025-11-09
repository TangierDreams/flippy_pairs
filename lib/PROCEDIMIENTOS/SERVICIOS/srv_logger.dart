import 'dart:io';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fechas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
// IMPORTANTE: Se necesita la librería 'synchronized' para garantizar la exclusividad.
import 'package:synchronized/synchronized.dart';

class SrvLogger {
  // =========================================================================
  // 1. OBJETO LOCK (MUTEX)
  // Objeto Lock estático. Se utiliza para serializar todas las llamadas
  // asíncronas a 'grabarLog' y evitar condiciones de carrera (corrupción de datos).
  // =========================================================================
  static final _logLock = Lock();

  static late File _logFile;
  static late File _oldLogFile;
  static const int _maxSizeBytes = 50 * 1024;
  static bool _inicializado = false;

  //----------------------------------------------------------------------------
  // Graba una línea de log:
  //----------------------------------------------------------------------------
  static Future<void> grabarLog(String modulo, String funcion, String mensaje) async {
    // =========================================================================
    // PROTECCIÓN CON 'synchronized'
    // Toda la ejecución asíncrona (lectura, inicialización, escritura) se
    // realiza dentro de este bloque, garantizando que solo una llamada
    // se procese a la vez. Esto resuelve el problema de la corrupción del log.
    // =========================================================================
    await _logLock.synchronized(() async {
      if (!DatosGenerales.logsActivados) {
        return;
      }

      if (!_inicializado) {
        await inicializar();
      }

      try {
        await _verificarTamanyo();
        final String fecha = SrvFechas.hoyEnYYYYMMDD();
        final String hora = SrvFechas.ahoraEnHHMMSSCC();
        final String linea = '$fecha;$hora;$modulo;$funcion;$mensaje\n';
        await _logFile.writeAsString(linea, mode: FileMode.append, flush: true);
        debugPrint(linea);
      } catch (e) {
        debugPrint('Error al grabar log (dentro del lock): $e');
      }
    }); // El lock se libera aquí, permitiendo que la siguiente llamada en cola continúe.
  }

  //----------------------------------------------------------------------------
  // Si el archivo supera x KB, lo grabamos como "_old.csv" y creamos uno
  // nuevo.
  //----------------------------------------------------------------------------
  static Future<void> _verificarTamanyo() async {
    if (await _logFile.exists()) {
      final int tamano = await _logFile.length();
      if (tamano > _maxSizeBytes) {
        if (await _oldLogFile.exists()) {
          await _oldLogFile.delete();
        }
        await _logFile.rename(_oldLogFile.path);
        await _logFile.create(recursive: true);
      }
    }
  }

  //----------------------------------------------------------------------------
  // Inicializa el logger (solo se ejecuta una vez, ahora protegida por el lock)
  //----------------------------------------------------------------------------
  static Future<void> inicializar() async {
    if (_inicializado) return;

    final Directory baseDir = await getApplicationDocumentsDirectory();
    final Directory logDir = Directory('${baseDir.path}/logs');
    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }

    DatosGenerales.rutaArchivoLogs = '${logDir.path}/${DatosGenerales.nombreArchivoLogs}';
    DatosGenerales.rutaArchivoLogsOld =
        '${logDir.path}/${DatosGenerales.nombreArchivoLogs.split('.').first}_old.${DatosGenerales.nombreArchivoLogs.split('.').last}';

    _logFile = File(DatosGenerales.rutaArchivoLogs);
    _oldLogFile = File(DatosGenerales.rutaArchivoLogsOld);

    if (!(await _logFile.exists())) {
      await _logFile.create(recursive: true);
    }
    _inicializado = true;
  }
}
