import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> widJuegoAcabado(
  BuildContext context,
  int puntosDelJuego,
  int pTotalPuntos,
  String pTiempo, {
  VoidCallback? pFuncionDeCallback,
}) {
  bool gana = puntosDelJuego > 0 ? true : false;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gana ? [Colores.segundo, Colores.tercero] : [Colores.quinto, Colores.primero],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "😅 Game Over!",
                style: GoogleFonts.luckiestGuy(
                  fontSize: 32,
                  color: Colores.blanco,
                  shadows: [Shadow(blurRadius: 6, color: Colores.fondo, offset: Offset(2, 2))],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                gana
                    ? "You've won $puntosDelJuego points in this game. Congratulations!"
                    : "You've lost $puntosDelJuego points in this game. Oooops!",
                style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Your total score is $pTotalPuntos points.",
                style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "You finished the game in $pTiempo minutes.",
                style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // NEW: Two buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Finish button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colores.cuarto,
                      foregroundColor: Colores.blanco,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // close dialog
                      Navigator.of(context).pop(); // go back home
                    },
                    child: const Text("Finish"),
                  ),

                  // Play Again button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colores.segundo,
                      foregroundColor: Colores.blanco,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // close dialog
                      if (pFuncionDeCallback != null) pFuncionDeCallback();
                    },
                    child: const Text("Play Again"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
