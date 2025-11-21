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
  contrasteFondo,
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
    ColorKey.apoyo: Colors.blueAccent,
    ColorKey.onPrincipal: Colors.white,
    ColorKey.onDestacado: Colors.white,
    ColorKey.onResaltado: Colors.white,
    ColorKey.onMuyResaltado: Colors.white,
    ColorKey.onApoyo: Colors.white,
    ColorKey.aviso: const Color.fromARGB(255, 247, 120, 2),
    ColorKey.error: Colors.red,
    ColorKey.exito: const Color.fromARGB(255, 2, 139, 43),
    ColorKey.fondo: Color(0xFFE0E0E0),
    ColorKey.contrasteFondo: Color.fromARGB(255, 255, 255, 255),
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
    ColorKey.error: const Color.fromARGB(255, 158, 43, 35),
    ColorKey.exito: const Color.fromARGB(255, 1, 97, 30),
    ColorKey.fondo: Color.fromARGB(255, 30, 30, 30),
    ColorKey.contrasteFondo: Color.fromARGB(255, 139, 139, 139),
    ColorKey.texto: Colors.white70,
    ColorKey.blanco: Colors.white,
    ColorKey.negro: Colors.black,
  };

  static bool _estamosEnModoOscuro(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }

  static Color get(BuildContext context, ColorKey pColor) {
    final tema = _estamosEnModoOscuro(context) ? _temaOscuro : _temaClaro;
    return tema[pColor]!;
  }
}
