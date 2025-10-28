import 'dart:io';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fechas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
//

// IMPORTANTE: Se necesita la librería 'synchronized' para garantizar la exclusividad.
import 'package:synchronized/synchronized.dart';

class SrvLogger {
  // =========================================================================
  // 1. OBJETO LOCK (MUTEX)
  // =========================================================================
  /// Objeto Lock estático. Se utiliza para serializar todas las llamadas
  /// asíncronas a 'grabarLog' y evitar condiciones de carrera (corrupción de datos).
  static final _logLock = Lock();

  // Variables existentes
  static late File _logFile;
  static late File _oldLogFile;
  static const int _maxSizeBytes = 50 * 1024;
  static bool _inicializado = false;

  //----------------------------------------------------------------------------
  // Graba una línea de log:
  //----------------------------------------------------------------------------
  static Future<void> grabarLog(String modulo, String funcion, String mensaje) async {
    // =========================================================================
    // 2. PROTECCIÓN CON 'synchronized'
    // =========================================================================
    // Toda la ejecución asíncrona (lectura, inicialización, escritura) se
    // realiza dentro de este bloque, garantizando que solo una llamada
    // se procese a la vez. Esto resuelve el problema de la corrupción del log.
    await _logLock.synchronized(() async {
      // Chequeo de logs activados (se mantiene fuera del try/catch)
      if (!DatosGenerales.logsActivados) {
        return;
      }

      // La inicialización ahora es segura. Las llamadas concurrentes esperarán
      // aquí si ya hay una inicialización en curso.
      if (!_inicializado) {
        await _inicializar();
      }

      try {
        // La verificación de tamaño se realiza de forma atómica.
        await _verificarTamanyo();

        // La construcción de la línea es segura dentro del lock.
        final String fecha = SrvFechas.hoyEnYYYYMMDD();
        final String hora = SrvFechas.ahoraEnHHMMSS();
        final String linea = '$fecha;$hora;$modulo;$funcion;$mensaje\n';

        // La escritura en el archivo es atómica, previniendo datos incompletos.
        await _logFile.writeAsString(linea, mode: FileMode.append, flush: true);
      } catch (e) {
        // Si hay un fallo de I/O durante la escritura, lo capturamos.
        debugPrint('Error al grabar log (dentro del lock): $e');
      }
    }); // El lock se libera aquí, permitiendo que la siguiente llamada en cola continúe.
  }

  //----------------------------------------------------------------------------
  // Si el archivo supera 100 KB, lo grabamos como "_old.csv" y creamos uno
  // nuevo. (No requiere cambios, ya está protegida por el lock de grabarLog)
  //----------------------------------------------------------------------------
  static Future<void> _verificarTamanyo() async {
    // Usamos el operador ! (null check) ya que sabemos que _logFile fue inicializado
    // por la función _inicializar que se ejecutó antes.
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
