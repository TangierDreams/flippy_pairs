import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SrvLogger {
  static late File _logFile;
  static late File _oldLogFile;
  static const int _maxSizeBytes = 100 * 1024; // 100 KB
  static bool _inicializado = false;

  /// Inicializa el logger (solo se ejecuta una vez)
  static Future<void> inicializar({String nombreArchivo = 'FlippyPairs.csv'}) async {
    if (_inicializado) return;

    final Directory dir = await getApplicationDocumentsDirectory();
    final String logPath = '${dir.path}/$nombreArchivo';
    final String oldLogPath = '${dir.path}/$nombreArchivo.old';

    _logFile = File(logPath);
    _oldLogFile = File(oldLogPath);

    if (!(await _logFile.exists())) {
      await _logFile.create(recursive: true);
    }

    _inicializado = true;
  }

  /// Graba una línea de log con formato:
  /// YYYY-MM-DD HH:MM:SS | modulo | funcion | mensaje
  static Future<void> grabarLog(String modulo, String funcion, String mensaje) async {
    if (!_inicializado) {
      await inicializar();
    }

    try {
      await _verificarTamano();

      final DateTime ahora = DateTime.now();
      final String fecha =
          "${ahora.year.toString().padLeft(4, '0')}-${ahora.month.toString().padLeft(2, '0')}-${ahora.day.toString().padLeft(2, '0')}";
      final String hora =
          "${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}:${ahora.second.toString().padLeft(2, '0')}";
      final String linea = '$fecha;$hora;$modulo;$funcion;$mensaje\n';

      await _logFile.writeAsString(linea, mode: FileMode.append);
    } catch (e) {
      // No lanzamos excepción para no romper la app
      debugPrint('Error al grabar log: $e');
    }
  }

  /// Si el archivo supera 100 KB:
  /// - elimina el .old si existe
  /// - renombra el actual a .old
  /// - crea uno nuevo vacío
  static Future<void> _verificarTamano() async {
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
}
