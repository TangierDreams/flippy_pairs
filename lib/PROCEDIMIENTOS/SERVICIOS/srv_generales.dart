import 'package:flutter/material.dart';

class SrvGenerales {
  static SizedBox espacioVertical(BuildContext pContexto, double pPorcentaje) {
    final altoPantalla = MediaQuery.of(pContexto).size.height;
    return SizedBox(height: altoPantalla * (pPorcentaje / 100));
  }
}
