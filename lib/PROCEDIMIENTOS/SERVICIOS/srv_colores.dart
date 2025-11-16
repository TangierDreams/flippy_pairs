import 'package:flutter/material.dart';

class SrvColores {
  static final Map<String, Color> _temaClaro = {
    'primero': const Color.fromARGB(255, 58, 75, 167),
    'segundo': Colors.orange,
    'tercero': Colors.yellow,
    'cuarto': Colors.red,
    'quinto': Colors.cyan,
    'onPrimero': Colors.white,
    'onSegundo': Colors.white,
    'onTercero': Colors.white,
    'onCuarto': Colors.white,
    'fondo': Color(0xFFE0E0E0),
    'textos': Colors.black87,
    'blanco': Colors.white,
    'negro': Colors.black,
  };

  static final Map<String, Color> _temaOscuro = {
    'primero': const Color.fromARGB(255, 73, 93, 207),
    'segundo': Colors.orange,
    'tercero': Color.fromARGB(255, 55, 218, 63),
    'cuarto': Color(0xFFE53935),
    'quinto': Color(0xFF00ACC1),
    'onPrimero': Colors.white70,
    'onSegundo': Colors.black,
    'onTercero': Colors.black,
    'onCuarto': Colors.black,
    'fondo': Color(0xFF121212),
    'textos': Colors.white70,
    'blanco': Colors.white,
    'negro': Colors.black,
  };

  static bool _estamosEnModoOscuro(BuildContext pContexto) {
    final Brightness brightness = MediaQuery.of(pContexto).platformBrightness;
    return brightness == Brightness.dark;
  }

  static Color get(BuildContext pContexto, String pColor) {
    final tema = _estamosEnModoOscuro(pContexto) ? _temaOscuro : _temaClaro;
    return tema[pColor]!;
  }
}
