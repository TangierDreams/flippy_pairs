import 'package:flutter/material.dart';

class SrvFuncionesGenericas {
  static SizedBox espacioVertical(BuildContext context, double pPorcentaje) {
    final altoPantalla = MediaQuery.of(context).size.height;
    return SizedBox(height: altoPantalla * (pPorcentaje / 100));
  }
}
