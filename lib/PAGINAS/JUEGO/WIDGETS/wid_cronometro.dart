import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/srv_cronometro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidCronometro extends StatelessWidget {
  const WidCronometro({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos a los cambios en SrvCronometro.tiempEnMMSS para modificar la UI.
    return ValueListenableBuilder<String>(
      valueListenable: SrvCronometro.tiempoEnMMSS,
      builder: (context, tiempoEnMMSS, child) {
        return Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [SrvColores.get(context, ColorKey.apoyo), SrvColores.get(context, ColorKey.principal)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: SrvColores.get(context, ColorKey.principal), width: 3),
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
                  'Timer',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comicNeue(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: SrvColores.get(context, ColorKey.onPrincipal),
                    shadows: [
                      Shadow(
                        color: SrvColores.get(context, ColorKey.principal),
                        blurRadius: 3,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                Text(
                  tiempoEnMMSS,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comicNeue(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: SrvColores.get(context, ColorKey.onPrincipal),
                    shadows: [
                      Shadow(
                        color: SrvColores.get(context, ColorKey.principal),
                        blurRadius: 3,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
