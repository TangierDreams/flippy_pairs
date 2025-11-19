import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SrvFuentes {
  static TextStyle chewy(BuildContext context, double pSize, Color pColor, {Color? pColorSombra}) {
    //pColorSombra ??= SrvColores.get(context, ColorKey.texto);
    final output = GoogleFonts.chewy(
      textStyle: TextStyle(
        fontSize: pSize,
        height: 0.7,
        color: pColor,
        shadows: pColorSombra == null ? null : [Shadow(blurRadius: 4, color: pColorSombra, offset: Offset(2, 2))],
      ),
    );
    return output;
  }

  static TextStyle luckiestGuy(BuildContext context, double pSize, Color pColor, {Color? pColorSombra}) {
    //pColorSombra ??= SrvColores.get(context, ColorKey.texto);
    final output = GoogleFonts.luckiestGuy(
      textStyle: TextStyle(
        fontSize: pSize,
        //height: 0.9,
        color: pColor,
        shadows: pColorSombra == null ? null : [Shadow(blurRadius: 8, color: pColorSombra, offset: Offset(3, 3))],
      ),
    );
    return output;
  }
}
