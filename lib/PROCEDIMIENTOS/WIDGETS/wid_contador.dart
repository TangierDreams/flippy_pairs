import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [SrvColores.get(context, 'quinto'), SrvColores.get(context, 'primero')],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: SrvColores.get(context, 'primero'), width: 3),
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
              pTexto,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.comicNeue(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: SrvColores.get(context, 'onPrimero'),
                shadows: [Shadow(color: SrvColores.get(context, 'primero'), blurRadius: 3, offset: const Offset(2, 2))],
              ),
            ),
            WidDigitRoller(
              key: ValueKey('${pModo}_roller'),
              value: pContador,
              style: GoogleFonts.comicNeue(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: SrvColores.get(context, 'onPrimero'),
                shadows: [Shadow(color: SrvColores.get(context, 'primero'), blurRadius: 3, offset: const Offset(2, 2))],
              ),
              stepDuration: const Duration(milliseconds: 100),
              maxSteps: 15,
            ),
          ],
        ),
      ),
    );
  }
}
