import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DatosGenerales {
  static const String nombreApp = 'Flippy Pairs';
  static const String logoApp = 'assets/imagenes/general/app_logo.png';
  static const String supabaseUrl = 'https://nygzlnrhbrdvjjhrbsdz.supabase.co';
  static const String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im55Z3psbnJoYnJkdmpqaHJic2R6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE3MDQ3MTMsImV4cCI6MjAxNzI4MDcxM30.0ioZe3S_uqanr_Ulm_yWVxYEOHi7pHCNHKyu9zsq8fE';
}

class InfoJuego {
  static int filasSeleccionadas = 3;
  static int columnasSeleccionadas = 2;
  static int temaSeleccionado = 0;
  static int nivelSeleccionado = 0;
  static String listaSeleccionada = 'iconos';
  static const niveles = [
    {'titulo': '3x2', 'filas': 3, 'columnas': 2, 'puntosMas': 10, 'puntosMenos': 11},
    {'titulo': '4x3', 'filas': 4, 'columnas': 3, 'puntosMas': 10, 'puntosMenos': 9},
    {'titulo': '5x4', 'filas': 5, 'columnas': 4, 'puntosMas': 10, 'puntosMenos': 7},
    {'titulo': '6x5', 'filas': 6, 'columnas': 5, 'puntosMas': 10, 'puntosMenos': 8},
    {'titulo': '8x7', 'filas': 8, 'columnas': 7, 'puntosMas': 10, 'puntosMenos': 8},
    {'titulo': '9x8', 'filas': 9, 'columnas': 8, 'puntosMas': 10, 'puntosMenos': 7},
  ];
}

class Colores {
  static const Color primero = Colors.indigo;
  static const Color segundo = Colors.orange;
  static const Color tercero = Colors.yellow;
  static const Color cuarto = Colors.red;
  static const Color quinto = Colors.cyan;
  static const Color onPrimero = Colors.white;
  static final Color fondo = Colors.grey.shade300;
  static final Color textos = Colors.grey.shade800;
  static final Color blanco = Colors.white;
  static final Color negro = Colors.black;
}

class Textos {
  static final textStyleOrange32 = GoogleFonts.luckiestGuy(
    textStyle: TextStyle(
      fontSize: 32,
      height: 0.9,
      color: Colores.segundo,
      shadows: [Shadow(blurRadius: 8, color: Colores.textos, offset: Offset(3, 3))],
    ),
  );

  static final textStyleOrange30 = GoogleFonts.chewy(
    textStyle: TextStyle(
      fontSize: 30,
      height: 0.7,
      color: Colores.segundo,
      shadows: [Shadow(blurRadius: 4, color: Colores.textos, offset: Offset(2, 2))],
    ),
  );

  static final textStyleOrange28 = GoogleFonts.luckiestGuy(
    textStyle: TextStyle(
      fontSize: 28,
      //height: 0.9,
      color: Colores.segundo,
      shadows: [Shadow(blurRadius: 8, color: Colores.textos, offset: Offset(3, 3))],
    ),
  );

  static final textStyleYellow30 = GoogleFonts.chewy(
    textStyle: TextStyle(
      fontSize: 30,
      height: 0.7,
      color: Colores.tercero,
      shadows: [Shadow(blurRadius: 4, color: Colores.textos, offset: Offset(2, 2))],
    ),
  );

  static final textStyleYellow14 = GoogleFonts.chewy(
    textStyle: TextStyle(
      fontSize: 14,
      height: 0.7,
      color: Colores.tercero,
      shadows: [Shadow(blurRadius: 4, color: Colores.textos, offset: Offset(2, 2))],
    ),
  );

  static final TextStyle subtitle = TextStyle(fontSize: 20, color: Colores.onPrimero);

  static final TextStyle smallSubtitle = TextStyle(fontSize: 12, color: Colores.textos);

  static final TextStyle normal = TextStyle(fontSize: 14, color: Colores.textos);

  static final TextStyle highlighted = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colores.textos);

  static final TextStyle buttonDisabled = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colores.fondo);
}
