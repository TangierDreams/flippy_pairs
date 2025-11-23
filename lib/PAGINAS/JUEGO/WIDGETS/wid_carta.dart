//==============================================================================
// WIDGET DE CARTA
// Solo muestra una carta. Nada de lógica.
//==============================================================================

import 'dart:io';
import 'dart:math';
import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flutter/material.dart';

class WidCarta extends StatefulWidget {
  final int pIndex;
  final bool pEstaBocaArriba;
  final File pImagenCarta;
  final bool pDestello;
  final VoidCallback pCallBackFunction;

  const WidCarta({
    super.key,
    required this.pIndex,
    required this.pEstaBocaArriba,
    required this.pImagenCarta,
    required this.pDestello,
    required this.pCallBackFunction,
  });

  @override
  State<WidCarta> createState() => _WidCartaState();
}

class _WidCartaState extends State<WidCarta> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _animarRechazo() {
    if (!_shakeController.isAnimating) {
      SrvSonidos.error2();
      _shakeController.forward(from: 0);
    }
  }

  void _manejarTap() {
    // Verificar si la carta está bloqueada (misma lógica que en srv_juego)
    if (EstadoDelJuego.procesandoTareas ||
        widget.pEstaBocaArriba ||
        EstadoDelJuego.listaDeCartasEmparejadas[widget.pIndex]) {
      // ← Usamos widget.pIndex

      // Activar animación de rechazo
      _animarRechazo();
      return;
    }

    // Si no está bloqueada, ejecutar el callback normal
    widget.pCallBackFunction();
  }

  @override
  Widget build(BuildContext context) {
    int velocidadJuego = SrvDiskette.leerValor(DisketteKey.velocidadJuego, defaultValue: 1);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTapDown: (TapDownDetails details) {
          _manejarTap();
        },
        child: AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            // Cálculo de la vibración
            final shake = _shakeController.value * 15.0 * sin(_shakeController.value * 25);
            return Transform.translate(offset: Offset(shake, 0), child: child);
          },
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: widget.pEstaBocaArriba ? 1 : 0),
            duration: Duration(
              milliseconds: widget.pEstaBocaArriba ? GameSpeed.giro[velocidadJuego] : GameSpeed.giro[velocidadJuego],
            ),
            builder: (context, value, child) {
              double angle = value * pi;
              bool mostrarCarta = value > 0.5;
              final Color colorBase = mostrarCarta
                  ? SrvColores.get(context, ColorKey.onPrincipal)
                  : SrvColores.get(context, ColorKey.principal);

              return AnimatedScale(
                scale: widget.pDestello ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: widget.pDestello ? colorBase.withValues(alpha: 0.95) : colorBase,
                    boxShadow: widget.pDestello
                        ? [
                            BoxShadow(
                              color: SrvColores.get(context, ColorKey.muyResaltado).withValues(alpha: 0.80),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ]
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
                                    ? Image.file(widget.pImagenCarta)
                                    : Image.asset('assets/imagenes/interrogacion.png'),
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
        ),
      ),
    );
  }
}
