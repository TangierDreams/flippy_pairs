import 'dart:io';
import 'dart:math';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flutter/material.dart';

class WidCarta extends StatelessWidget {
  final bool pEstaBocaArriba;
  final File pImagenCarta;
  final bool pDestello;
  final VoidCallback pCallBackFunction;

  const WidCarta({
    super.key,
    required this.pEstaBocaArriba,
    required this.pImagenCarta,
    required this.pDestello,
    required this.pCallBackFunction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //SrvSonidos.flip();
        pCallBackFunction();
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 0,
          end: pEstaBocaArriba ? 1 : 0, // 0 = back, 1 = front
        ),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          double angle = value * pi;
          bool mostrarCarta = value > 0.5;

          final Color colorBase = mostrarCarta ? Colores.onPrimero : Colores.primero;

          // --- NUEVO BLOQUE: animación de brillo y escala pulsante ---
          return AnimatedScale(
            scale: pDestello ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: pDestello ? colorBase.withValues(alpha: 0.95) : colorBase,
                boxShadow: pDestello
                    ? [BoxShadow(color: Colores.cuarto.withValues(alpha: 0.80), blurRadius: 20, spreadRadius: 4)]
                    : [],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, dimensiones) {
                      final double dynamicPadding = dimensiones.maxHeight * 0.16;

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(mostrarCarta ? pi : 0),
                        child: Padding(
                          padding: EdgeInsets.all(dynamicPadding),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: mostrarCarta
                                ? Image.file(pImagenCarta)
                                : Image.asset('assets/imagenes/general/interrogacion.png'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
