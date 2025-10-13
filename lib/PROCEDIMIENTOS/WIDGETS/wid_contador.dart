import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_digit_roller.dart';
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
            WidDigitRoller(
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
