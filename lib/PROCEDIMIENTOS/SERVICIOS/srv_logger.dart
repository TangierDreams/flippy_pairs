import 'dart:io';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fechas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SrvLogger {
  static late File _logFile;
  static late File _oldLogFile;
  static const int _maxSizeBytes = 100 * 1024; // 100 KB
  static bool _inicializado = false;

  //----------------------------------------------------------------------------
  // Graba una línea de log:
  //----------------------------------------------------------------------------
  static Future<void> grabarLog(String modulo, String funcion, String mensaje) async {
    if (!DatosGenerales.logsActivados) {
      return;
    }
    if (!_inicializado) {
      await _inicializar();
    }
    try {
      await _verificarTamanyo();
      final String fecha = SrvFechas.hoyEnYYYYMMDD();
      final String hora = SrvFechas.ahoraEnHHMMSS();
      final String linea = '$fecha;$hora;$modulo;$funcion;$mensaje\n';
      await _logFile.writeAsString(linea, mode: FileMode.append, flush: true);
    } catch (e) {
      // No lanzamos excepción para no romper la app
      debugPrint('Error al grabar log: $e');
    }
  }

  //----------------------------------------------------------------------------
  // Si el archivo supera 100 KB, lo grabamos como "_old.csv" y creamos uno
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
  //Inicializa el logger (solo se ejecuta una vez)
  //----------------------------------------------------------------------------
  static Future<void> _inicializar({String nombreArchivo = 'FlippyPairs.csv'}) async {
    if (_inicializado) return;

    final Directory baseDir = await getApplicationDocumentsDirectory();
    final Directory logDir = Directory('${baseDir.path}/FlippyLogs');
    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }

    final String logPath = '${logDir.path}/$nombreArchivo';
    final String oldLogPath = '${logDir.path}/${nombreArchivo.split('.').first}_old.${nombreArchivo.split('.').last}';
    _logFile = File(logPath);
    _oldLogFile = File(oldLogPath);

    if (!(await _logFile.exists())) {
      await _logFile.create(recursive: true);
    }
    _inicializado = true;
  }
}
