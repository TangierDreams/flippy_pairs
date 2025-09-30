import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DatosGenerales {
  static const String title = "Flippy Pairs";
  static const String logo = "assets/imagenes/app_logo.png";
}

class Colores {
  static const Color primary = Colors.indigo;
  static const Color contrast = Colors.white;
  static const Color accent = Colors.amber;
  static final Color background = Colors.grey.shade300;
  static final Color fontColor = Colors.grey.shade800;
}

class Textos {
  static final textStyleOrange32 = GoogleFonts.luckiestGuy(
    textStyle: const TextStyle(
      fontSize: 32,
      height: 0.9,
      color: Colors.orange,
      shadows: [Shadow(blurRadius: 8, color: Colors.black87, offset: Offset(3, 3))],
    ),
  );

  static final textStyleOrange30 = GoogleFonts.chewy(
    textStyle: const TextStyle(
      fontSize: 30,
      height: 0.7,
      color: Colors.orange,
      shadows: [Shadow(blurRadius: 4, color: Colors.black54, offset: Offset(2, 2))],
    ),
  );

  static final textStyleOrange28 = GoogleFonts.luckiestGuy(
    textStyle: const TextStyle(
      fontSize: 28,
      //height: 0.9,
      color: Colors.orange,
      shadows: [Shadow(blurRadius: 8, color: Colors.black87, offset: Offset(3, 3))],
    ),
  );

  static final textStyleYellow30 = GoogleFonts.chewy(
    textStyle: const TextStyle(
      fontSize: 30,
      height: 0.7,
      color: Colors.yellow,
      shadows: [Shadow(blurRadius: 4, color: Colors.black54, offset: Offset(2, 2))],
    ),
  );

  static final textStyleYellow14 = GoogleFonts.chewy(
    textStyle: const TextStyle(
      fontSize: 14,
      height: 0.7,
      color: Colors.yellow,
      shadows: [Shadow(blurRadius: 4, color: Colors.black54, offset: Offset(2, 2))],
    ),
  );

  static final TextStyle subtitle = TextStyle(fontSize: 20, color: Colores.contrast);

  static final TextStyle smallSubtitle = TextStyle(fontSize: 12, color: Colores.contrast);

  static final TextStyle normal = TextStyle(fontSize: 14, color: Colores.fontColor);

  static final TextStyle highlighted = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colores.fontColor);

  static final TextStyle buttonDisabled = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey);
}
