import 'dart:convert';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_datos_generales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:http/http.dart' as http;

class SrvTracking {
  static Future<void> obtenerDatos() async {
    final uri = Uri.parse('https://ipinfo.io/json?token=${SrvDatosGenerales.ipInfoKey}');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        SrvDiskette.guardarValor(DisketteKey.idPais, data['country']);
        SrvDiskette.guardarValor(DisketteKey.ciudad, data['city']);
        SrvDiskette.guardarValor(DisketteKey.ip, data['ip']);
        SrvLogger.grabarLog(
          'srv_tracking',
          'obtenerDatos()',
          "IpInfo: ${data['country']} - ${data['city']} - ${data['ip']}",
        );
      } else {
        SrvLogger.grabarLog(
          'srv_tracking',
          'obtenerDatos()',
          'Fallo al cargar la información de la IP: ${response.statusCode}',
        );
      }
    } catch (error) {
      SrvLogger.grabarLog('srv_tracking', 'obtenerDatos()', 'Error en la conexión: $error');
    }
  }
}
