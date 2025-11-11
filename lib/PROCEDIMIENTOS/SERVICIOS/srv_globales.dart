import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DatosGenerales {
  static const String nombreApp = 'Flippy Pairs';
  static const bool logsActivados = true;
  static const String nombreArchivoLogs = "flippypairs.csv";
  static String rutaArchivoLogs = '';
  static String rutaArchivoLogsOld = '';
  static const String logoApp = 'assets/imagenes/general/app_logo.png';
  static const String supabaseUrl = 'https://dvkiegomytwhagitceje.supabase.co';
  static const String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR2a2llZ29teXR3aGFnaXRjZWplIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI2NTg1NzEsImV4cCI6MjA3ODIzNDU3MX0.jO91Qji7IyMQRpr-PWn__Qj89h64amjrijyX2o_IpHo';
}

class Colores {
  static const Color primero = Colors.indigo;
  static const Color segundo = Colors.orange;
  static const Color tercero = Colors.yellow;
  static const Color cuarto = Colors.red;
  static const Color quinto = Colors.cyan;
  static const Color onPrimero = Colors.white;
  static const Color fondo = Colors.black12;
  //static final Color fondo = Colors.grey.shade300;
  static const Color textos = Colors.black54;
  static const Color blanco = Colors.white;
  static const Color negro = Colors.black;
}

class Textos {
  static TextStyle chewy(double pSize, Color pColor, {Color? pColorSombra}) {
    pColorSombra ??= Colores.textos;
    final output = GoogleFonts.chewy(
      textStyle: TextStyle(
        fontSize: pSize,
        height: 0.7,
        color: pColor,
        shadows: [Shadow(blurRadius: 4, color: pColorSombra, offset: Offset(2, 2))],
      ),
    );
    return output;
  }

  static TextStyle luckiestGuy(double pSize, Color pColor, {Color? pColorSombra}) {
    pColorSombra ??= Colores.textos;
    final output = GoogleFonts.luckiestGuy(
      textStyle: TextStyle(
        fontSize: pSize,
        //height: 0.9,
        color: pColor,
        shadows: [Shadow(blurRadius: 8, color: pColorSombra, offset: Offset(3, 3))],
      ),
    );
    return output;
  }
}
