import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flutter/material.dart';

class WidFlechaAtras extends StatelessWidget {
  const WidFlechaAtras({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colores.tercero,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colores.segundo, width: 3),
        boxShadow: [
          BoxShadow(color: Colores.cuarto, blurRadius: 10, offset: const Offset(4, 4), spreadRadius: 1),
          BoxShadow(color: Colores.quinto, blurRadius: 5, offset: const Offset(-3, -3)),
        ],
        gradient: LinearGradient(
          colors: [Colores.segundo, Colores.tercero],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Efecto de highlight
          Positioned(top: 4, left: 4, child: SizedBox(width: 12, height: 12)),
          // Flecha extra gruesa
          Center(
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colores.blanco,
              size: 30,
              weight: 1000, // Máximo grosor
              shadows: [Shadow(color: Colores.segundo, blurRadius: 4, offset: const Offset(2, 2))],
            ),
          ),
        ],
      ),
    );
  }
}
