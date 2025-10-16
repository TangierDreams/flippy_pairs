import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Fechas {
  //----------------------------------------------------------------------------
  // Devolvemos la fecha actual en formato yyyy-mm-dd:
  //----------------------------------------------------------------------------
  static String hoyEnYYYYMMDD() {
    final DateFormat formateador = DateFormat('yyyy-MM-dd');
    final DateTime ahora = DateTime.now();
    return formateador.format(ahora);
  }

  //----------------------------------------------------------------------------
  // Convertimos un valor en segundos a minutos:segundos.
  //----------------------------------------------------------------------------
  static String segundosAMinutosYSegundos(int pSegundos) {
    int minutos = pSegundos ~/ 60;
    int segundos = pSegundos % 60;
    String sMinutos = minutos.toString().padLeft(2, '0');
    String sSegundos = segundos.toString().padLeft(2, '0');
    final output = '$sMinutos:$sSegundos';
    debugPrint("Minutos y segundos: $output");
    return output;
  }
}
