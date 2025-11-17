import 'package:flutter/material.dart';

enum ColorKey {
  principal,
  destacado,
  resaltado,
  muyResaltado,
  apoyo,
  onPrincipal,
  onDestacado,
  onResaltado,
  onMuyResaltado,
  onApoyo,
  aviso,
  error,
  exito,
  fondo,
  texto,
  blanco,
  negro,
}

class SrvColores {
  static final Map<ColorKey, Color> _temaClaro = {
    ColorKey.principal: const Color.fromARGB(255, 58, 75, 167),
    ColorKey.destacado: Colors.orange,
    ColorKey.resaltado: Colors.yellow,
    ColorKey.muyResaltado: Colors.red,
    ColorKey.apoyo: Colors.cyan,
    ColorKey.onPrincipal: Colors.white,
    ColorKey.onDestacado: Colors.white,
    ColorKey.onResaltado: Colors.white,
    ColorKey.onMuyResaltado: Colors.white,
    ColorKey.onApoyo: Colors.white,
    ColorKey.aviso: const Color.fromARGB(255, 247, 120, 2),
    ColorKey.error: Colors.red,
    ColorKey.exito: const Color.fromARGB(255, 3, 212, 66),
    ColorKey.fondo: Color(0xFFE0E0E0),
    ColorKey.texto: Colors.black87,
    ColorKey.blanco: Colors.white,
    ColorKey.negro: Colors.black,
  };

  static final Map<ColorKey, Color> _temaOscuro = {
    ColorKey.principal: const Color.fromARGB(255, 73, 93, 207),
    ColorKey.destacado: Colors.orange,
    ColorKey.resaltado: Color(0xFF00ACC1),
    ColorKey.muyResaltado: Color(0xFFE53935),
    ColorKey.apoyo: Color(0xFF00ACC1),
    ColorKey.onPrincipal: Colors.white70,
    ColorKey.onDestacado: Colors.black,
    ColorKey.onResaltado: Colors.black,
    ColorKey.onMuyResaltado: Colors.black,
    ColorKey.onApoyo: Colors.black,
    ColorKey.aviso: const Color.fromARGB(255, 247, 120, 2),
    ColorKey.error: Colors.red,
    ColorKey.exito: const Color.fromARGB(255, 3, 212, 66),
    ColorKey.fondo: Color.fromARGB(255, 30, 30, 30),
    ColorKey.texto: Colors.white70,
    ColorKey.blanco: Colors.white,
    ColorKey.negro: Colors.black,
  };

  static bool _estamosEnModoOscuro(BuildContext pContexto) {
    final Brightness brightness = MediaQuery.of(pContexto).platformBrightness;
    return brightness == Brightness.dark;
  }

  static Color get(BuildContext pContexto, ColorKey pColor) {
    final tema = _estamosEnModoOscuro(pContexto) ? _temaOscuro : _temaClaro;
    return tema[pColor]!;
  }
}
