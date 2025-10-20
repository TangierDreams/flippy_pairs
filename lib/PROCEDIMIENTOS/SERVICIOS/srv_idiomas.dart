import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flutter/material.dart';

class SrvIdiomas {
  static final ValueNotifier<String> idiomaSeleccionado = ValueNotifier<String>('en');

  //----------------------------------------------------------------------------
  // Cargamos el idioma desde las shared preferences.
  //----------------------------------------------------------------------------

  static Future<void> inicializar() async {
    final valor = await SrvDiskette.leerValor(DisketteKey.idioma, defaultValue: 'en');
    idiomaSeleccionado.value = valor;
  }

  //----------------------------------------------------------------------------
  // Cambiamos de idioma y notificamos el cambio a la app.
  //----------------------------------------------------------------------------

  static Future<void> cambiarIdioma(String nuevoIdioma) async {
    await SrvDiskette.guardarValor(DisketteKey.idioma, nuevoIdioma);
    SrvLogger.grabarLog('srv_idiomas', 'cambiarIdioma()', 'Hemos cambiado al idioma: $nuevoIdioma');
    idiomaSeleccionado.value = nuevoIdioma; // 🔔 Notifica el cambio de idioma
  }
}
