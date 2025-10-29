import 'dart:io';

import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flutter/material.dart';

// El modelo de datos LogEntry se mantiene intacto.
class LogEntry {
  final String date;
  final String time;
  final String module;
  final String function;
  final String message;
  final DateTime fullTimestamp;

  LogEntry({
    required this.date,
    required this.time,
    required this.module,
    required this.function,
    required this.message,
  }) : fullTimestamp = DateTime.parse('${date.replaceAll('-', '')}T$time');
}

class PagLogs extends StatefulWidget {
  const PagLogs({super.key});

  @override
  State<PagLogs> createState() => _PagLogsState();
}

class _PagLogsState extends State<PagLogs> {
  late Future<List<LogEntry>> _logFuture;

  @override
  void initState() {
    super.initState();
    SrvLogger.grabarLog('pag_logs', 'initState()', 'Entramos en la pagina de mostrar los logs');
    _logFuture = _loadAndParseLogs();
  }

  @override
  void dispose() {
    SrvLogger.grabarLog('pag_logs', 'dispose()', 'Salimos de la pagina de mostrar los logs');
    super.dispose();
  }

  // ===========================================================================
  // Carga y parsea el contenido de un único archivo.
  // Esto aísla la lógica de parseo, haciéndola reutilizable.
  // ===========================================================================
  List<LogEntry> _parseLogContents(String contents) {
    final List<LogEntry> logs = [];
    final lines = contents.split('\n');

    for (var line in lines) {
      if (line.trim().isEmpty) continue;

      final parts = line.split(';');

      // Solo procesamos líneas que tienen al menos 5 partes.
      if (parts.length >= 5) {
        try {
          logs.add(
            LogEntry(
              date: parts[0],
              time: parts[1],
              module: parts[2],
              function: parts[3],
              // Une las partes restantes, por si el mensaje contenía ';'.
              message: parts.sublist(4).join(';'),
            ),
          );
        } catch (e) {
          // Manejo silencioso de errores de parseo (ej. si la fecha/hora es inválida)
          // Se puede registrar un error aquí si es necesario.
          debugPrint('Error al parsear línea de log: $line. Error: $e');
        }
      } else {
        logs.add(LogEntry(date: '1991-01-01', time: '00:00:00', module: '---', function: '---', message: line));
      }
    }
    return logs;
  }

  // ===========================================================================
  // Carga y parsea AMBOS archivos de log.
  // ===========================================================================
  Future<List<LogEntry>> _loadAndParseLogs() async {
    try {
      //final filePaths = await _getLogFilePaths();
      final currentFile = File(DatosGenerales.rutaArchivoLogs);
      final oldFile = File(DatosGenerales.rutaArchivoLogsOld);

      final List<LogEntry> allLogs = [];

      // 1. Leer el archivo de LOG ACTUAL (FlippyPairs.csv)
      if (await currentFile.exists()) {
        final currentContents = await currentFile.readAsString();
        allLogs.addAll(_parseLogContents(currentContents));
      } else {
        // Si no existe el archivo principal, es un error o es la primera ejecución
        SrvLogger.grabarLog('pag_logs', '_loadAndParseLogs()', 'Archivo de log principal no encontrado.');
      }

      // 2. Leer el archivo de LOG ANTIGUO (FlippyPairs_old.csv)
      if (await oldFile.exists()) {
        final oldContents = await oldFile.readAsString();
        allLogs.addAll(_parseLogContents(oldContents));
      }

      // Si no se encuentra ningún log, reportamos un mensaje claro.
      if (allLogs.isEmpty) {
        return [
          LogEntry(
            date: '1990-01-01',
            time: '00:00:00',
            module: 'INFO',
            function: 'Carga',
            message:
                'No se encontraron registros de logs en ${DatosGenerales.rutaArchivoLogs} ni en ${DatosGenerales.rutaArchivoLogsOld}',
          ),
        ];
      }

      // 3. Ordenar todos los logs combinados de MÁS RECIENTE a MÁS ANTIGUO
      // Esto unifica los registros de ambos archivos correctamente.
      allLogs.sort((a, b) => b.fullTimestamp.compareTo(a.fullTimestamp));

      return allLogs;
    } catch (e) {
      // Manejo de error para problemas de I/O o path
      SrvLogger.grabarLog('pag_logs', '_loadAndParseLogs()', 'FALLO FATAL al cargar o parsear logs: $e');
      return [
        LogEntry(
          date: '1990-01-01',
          time: '00:00:00',
          module: 'FATAL',
          function: 'Parser',
          message: 'Fallo al leer/parsear archivos de log. Revise permisos: $e',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Toolbar:
      appBar: WidToolbar(showMenuButton: false, showBackButton: true, subtitle: SrvTraducciones.get('subtitulo_app')),

      body: FutureBuilder<List<LogEntry>>(
        future: _logFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text('ERROR: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
            );
          }

          final logs = snapshot.data!;

          if (logs.isEmpty) {
            return const Center(
              child: Text('No hay registros de logs.', style: TextStyle(color: Colors.white70)),
            );
          }

          return Container(
            color: Colors.black, // Dark background for easy reading
            child: ListView.separated(
              itemCount: logs.length,
              separatorBuilder: (context, index) => const Divider(color: Colors.grey, height: 1, thickness: 0.5),
              itemBuilder: (context, index) {
                final entry = logs[index];

                // Highlight errors for quick identification
                Color messageColor = Colors.white;
                if (entry.message.toLowerCase().contains('error') || entry.message.toLowerCase().contains('fallo')) {
                  messageColor = Colors.redAccent;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timestamp and Location (Top Row)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Time & Date
                          Text('${entry.date} ${entry.time}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          const SizedBox(width: 10),
                          // Module and Function
                          Expanded(
                            child: Text(
                              '${entry.module}.${entry.function}',
                              style: const TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      // Message (Bottom Row)
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, top: 2.0),
                        child: Text(
                          entry.message,
                          style: TextStyle(color: messageColor, fontSize: 13, fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
