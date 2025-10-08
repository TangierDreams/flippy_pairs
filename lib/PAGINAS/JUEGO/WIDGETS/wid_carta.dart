import 'dart:math';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flutter/material.dart';

class WidCarta extends StatelessWidget {
  final bool pEstaBocaArriba;
  final String pImagenCarta;
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
        SrvSonidos.flip();
        pCallBackFunction();
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 0,
          end: pEstaBocaArriba ? 1 : 0, // 0 = back, 1 = front
        ),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          // Rotate Y axis from 0 → π
          double angle = value * pi;
          bool mostrarCarta = value > 0.5;

          // Determine the base color based on face-up status
          final Color colorBase = mostrarCarta ? Colores.onPrimero : Colores.primero;

          // Apply the flash color if flashing is true, otherwise use the base color.
          final Color colorFinal = pDestello ? Colores.tercero : colorBase;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateY(angle),
            child: Container(
              decoration: BoxDecoration(
                color: colorFinal,
                borderRadius: BorderRadius.circular(12),

                // Añadimos un borde al destello:
                border: pDestello ? Border.all(color: Colores.cuarto, width: 4) : null,
              ),
              child: Center(
                child: LayoutBuilder(
                  // Utilizamos LayoutBuilder para conocer el tamaño del contenedor:
                  builder: (BuildContext context, BoxConstraints dimensiones) {
                    // Definimos el padding como un porcentaje del tamaño del contenedor.

                    final double dynamicPadding = dimensiones.maxHeight * 0.16;

                    return Transform(
                      // Aplicamos una rotación para compensar el giro 3D si es la cara frontal
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..rotateY(mostrarCarta ? pi : 0), // Aplica PI (180 grados) solo si mostramos la carta
                      child: Padding(
                        padding: EdgeInsets.all(dynamicPadding),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: mostrarCarta
                              ? Image.asset(pImagenCarta)
                              : Image.asset('assets/imagenes/general/interrogacion.png'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
