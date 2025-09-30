import 'dart:math';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flutter/material.dart';

class WidCarta extends StatelessWidget {
  final bool pEstaBocaArriba;
  final IconData pImagenCarta;
  final VoidCallback pAlPresionar;
  final bool pDestello;

  const WidCarta({
    super.key,
    required this.pEstaBocaArriba,
    required this.pImagenCarta,
    required this.pAlPresionar,
    required this.pDestello,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Sonidos.flip();
        pAlPresionar(); // then call the passed function
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
          final Color colorBase = mostrarCarta ? const Color.fromARGB(255, 234, 238, 240) : Colores.primary;

          // Apply the flash color if flashing is true, otherwise use the base color.
          final Color colorFinal = pDestello ? Colors.yellow.shade700 : colorBase;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateY(angle),
            child: Container(
              decoration: BoxDecoration(
                //color: Colors.blueGrey[700],
                color: colorFinal,
                borderRadius: BorderRadius.circular(12),
                // OPTIONAL: Add a bright border during the flash for more impact
                border: pDestello ? Border.all(color: Colors.red.shade700, width: 4) : null,
              ),
              child: Center(
                child: mostrarCarta
                    ? Icon(
                        pImagenCarta, // Si mostrarCarta es true, sigue usando el Icon
                        color: const Color.fromARGB(255, 193, 12, 12),
                        size: 32,
                      )
                    : LayoutBuilder(
                        // 👈 1. Usamos LayoutBuilder para conocer el tamaño
                        builder: (BuildContext context, BoxConstraints constraints) {
                          // Definimos el padding como un porcentaje del tamaño del contenedor.
                          // Por ejemplo, el 8% de la altura máxima (constraints.maxHeight).
                          final double dynamicPadding = constraints.maxHeight * 0.16;

                          // Opcional: Establecer un límite mínimo y máximo para que no sea ridículo
                          // final double finalPadding = dynamicPadding.clamp(4.0, 12.0);

                          return Padding(
                            // 👈 2. Aplicamos el padding calculado
                            padding: EdgeInsets.all(dynamicPadding),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Image.asset('assets/imagenes/interrogacion.png'),
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
