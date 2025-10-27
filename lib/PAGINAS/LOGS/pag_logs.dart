import 'dart:io';

import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
  }) : fullTimestamp = DateTime.parse('${date.replaceAll('-', '')}T$time'); // Combine for sorting
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

  Future<String> _getLogFilePath() async {
    final Directory baseDir = await getApplicationDocumentsDirectory();
    final Directory logDir = Directory('${baseDir.path}/FlippyLogs');
    return '${logDir.path}/FlippyPairs.csv';
  }

  Future<List<LogEntry>> _loadAndParseLogs() async {
    try {
      final filePath = await _getLogFilePath();
      final file = File(filePath);

      if (!await file.exists()) {
        return [
          LogEntry(
            date: 'N/A',
            time: 'N/A',
            module: 'ERROR',
            function: 'FileCheck',
            message: 'Log file not found at: $filePath',
          ),
        ];
      }

      final contents = await file.readAsString();
      final lines = contents.split('\n');

      final List<LogEntry> logs = [];
      for (var line in lines) {
        if (line.trim().isEmpty) continue;

        // Split by the semicolon delimiter (;)
        final parts = line.split(';');

        // Expected 5 parts: Date;Time;Module;Function;Message
        if (parts.length >= 5) {
          logs.add(
            LogEntry(
              date: parts[0],
              time: parts[1],
              module: parts[2],
              function: parts[3],
              // Join the remaining parts back together in case the message contained semicolons
              message: parts.sublist(4).join(';'),
            ),
          );
        }
      }

      // Sort the logs from NEWEST to OLDEST (most useful for debugging)
      logs.sort((a, b) => b.fullTimestamp.compareTo(a.fullTimestamp));

      return logs;
    } catch (e) {
      return [
        LogEntry(
          date: 'N/A',
          time: 'N/A',
          module: 'FATAL',
          function: 'Parser',
          message: 'Failed to read/parse log file: $e',
        ),
      ];
    }
  }

  // void _refreshLogs() {
  //   setState(() {
  //     _logFuture = _loadAndParseLogs();
  //   });
  // }

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
