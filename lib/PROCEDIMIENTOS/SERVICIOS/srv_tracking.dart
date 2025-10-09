import 'dart:convert';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SrvTracking {
  //----------------------------------------------------------------------------
  // Obtener ISO del pais, nombre y ciudad a partir de la ip
  //----------------------------------------------------------------------------
  static Future<void> obtenerDatos() async {
    final uri = Uri.parse('https://ipapi.co/json');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      SrvDiskette.guardarValor(DisketteKey.idPais.name, data['country_code']);
      SrvDiskette.guardarValor(DisketteKey.nombrePais.name, data['country_name']);
      SrvDiskette.guardarValor(DisketteKey.ciudad.name, data['city']);
    } else {
      debugPrint('Fallo al cargar la información de la IP: ${response.statusCode}');
    }
  }
}
