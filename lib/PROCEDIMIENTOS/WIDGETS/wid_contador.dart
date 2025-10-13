import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_digit_roller_step.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidContador extends StatelessWidget {
  final String pTexto;
  final int pContador;
  final int pModo;

  const WidContador({super.key, required this.pContador, required this.pTexto, required this.pModo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colores.quinto, Colores.primero],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colores.primero, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      // decoration: BoxDecoration(
      //   color: pModo == 1 ? const Color.fromARGB(255, 226, 206, 27) : const Color.fromARGB(255, 169, 239, 252),
      //   borderRadius: BorderRadius.circular(12),
      //   border: Border.all(color: pModo == 1 ? Colores.segundo : Colores.primero, width: 3),
      //   boxShadow: [
      //     BoxShadow(color: pModo == 1 ? Colores.cuarto : Colores.primero, blurRadius: 8, offset: const Offset(4, 4)),
      //     BoxShadow(color: Colores.blanco, blurRadius: 4, offset: Offset(-2, -2)),
      //   ],
      // ),
      child: SizedBox(
        width: 50,
        child: Column(
          children: [
            Text(
              pTexto,
              style: GoogleFonts.comicNeue(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colores.blanco,
                shadows: [
                  Shadow(
                    color: pModo == 1 ? Colores.cuarto : Colores.primero,
                    blurRadius: 3,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
            WidDigitRollerStep(
              key: ValueKey("${pModo}_roller"),
              value: pContador,
              style: GoogleFonts.comicNeue(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colores.blanco,
                shadows: [
                  Shadow(
                    color: pModo == 1 ? Colores.cuarto : Colores.primero,
                    blurRadius: 3,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              stepDuration: const Duration(milliseconds: 100), // velocidad del giro
              maxSteps: 15, // máximo de pasos por salto
            ),
          ],
        ),
      ),
    );
  }
}
