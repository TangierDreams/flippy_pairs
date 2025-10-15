import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> widJuegoAcabado(
  BuildContext context,
  int puntosDelJuego,
  int pTotalPuntos,
  String pTiempo, {
  VoidCallback? pFuncionDeCallback,
}) async {
  bool gana = puntosDelJuego > 0 ? true : false;

  // 🔊 Reproducir sonido divertido según resultado
  if (gana) {
    SrvSonidos.sucess(); // o el sonido de victoria que tengas
  } else {
    SrvSonidos.error(); // o uno de error divertido
  }

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Fin del juego',
    transitionDuration: const Duration(milliseconds: 800),
    pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
    transitionBuilder: (context, anim1, anim2, child) {
      // Animación combinada: escala + opacidad
      return Transform.scale(
        scale: Curves.elasticOut.transform(anim1.value),
        child: Opacity(
          opacity: anim1.value,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colores.quinto, Colores.primero],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    gana ? '🎉 Excellent!' : '😅 Oooppss!',
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 36,
                      color: Colores.blanco,
                      shadows: [Shadow(blurRadius: 6, color: Colores.fondo, offset: const Offset(2, 2))],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    gana
                        ? "You've won $puntosDelJuego points in this game. Congratulations!"
                        : "You've lost ${puntosDelJuego.abs()} points in this game. You can do it better...",
                    style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your total score is $pTotalPuntos points.',
                    style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You finished the game in $pTiempo minutes.',
                    style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colores.cuarto,
                          foregroundColor: Colores.blanco,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (pFuncionDeCallback != null) {
                            pFuncionDeCallback();
                          }
                        },
                        child: Text('Play Again', style: GoogleFonts.baloo2(fontSize: 18)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colores.segundo,
                          foregroundColor: Colores.blanco,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {
                          SrvSonidos.goback();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text('Exit', style: GoogleFonts.baloo2(fontSize: 18)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
