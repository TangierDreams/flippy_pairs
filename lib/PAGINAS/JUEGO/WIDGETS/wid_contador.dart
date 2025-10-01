import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
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
        color: pModo == 1 ? Colores.tercero : const Color.fromARGB(255, 169, 239, 252),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: pModo == 1 ? Colores.segundo : Colores.primero, width: 3),
        boxShadow: [
          BoxShadow(color: pModo == 1 ? Colores.cuarto : Colores.primero, blurRadius: 8, offset: const Offset(4, 4)),
          BoxShadow(color: Colores.blanco, blurRadius: 4, offset: Offset(-2, -2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            pTexto,
            style: GoogleFonts.comicNeue(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colores.blanco,
              shadows: [
                Shadow(color: pModo == 1 ? Colores.cuarto : Colores.primero, blurRadius: 3, offset: const Offset(2, 2)),
              ],
            ),
          ),
          Text(
            "$pContador${pModo == 1 ? '\u200B' : '\u200C'}",
            style: GoogleFonts.comicNeue(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colores.blanco,
              shadows: [
                Shadow(color: pModo == 1 ? Colores.cuarto : Colores.primero, blurRadius: 3, offset: const Offset(2, 2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
