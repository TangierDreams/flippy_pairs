import 'dart:async';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidTemporizador extends StatefulWidget {
  final int pModo; // keep same "orange/blue" style as WidCounter

  const WidTemporizador({super.key, required this.pModo});

  @override
  State<WidTemporizador> createState() => WidTemporizadorState();
}

class WidTemporizadorState extends State<WidTemporizador> {
  late Timer _temporizador;
  int _segundos = 0;
  bool _enMarcha = false;

  @override
  void dispose() {
    if (_enMarcha) {
      _temporizador.cancel();
    }
    super.dispose();
  }

  void start() {
    if (_enMarcha) return;
    _enMarcha = true;
    _temporizador = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _segundos++;
      });
    });
  }

  void stop() {
    if (!_enMarcha) return;
    _temporizador.cancel();
    _enMarcha = false;
  }

  void reset() {
    stop();
    setState(() {
      _segundos = 0;
    });
  }

  // 💡 NEW PUBLIC GETTER: Exposes the formatted time string (mm:ss)

  String get getTiempoFormateado {
    return _formatearTiempo(_segundos);
  }

  String _formatearTiempo(int pTotalSegundos) {
    final minutos = (pTotalSegundos ~/ 60).toString().padLeft(2, '0');
    final segundos = (pTotalSegundos % 60).toString().padLeft(2, '0');
    return "$minutos:$segundos";
  }

  @override
  Widget build(BuildContext context) {
    final pModo = widget.pModo;
    return Container(
      width: 70,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: pModo == 1 ? Colores.tercero : Colores.quinto,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: pModo == 1 ? Colores.segundo : Colores.primero, width: 3),
        boxShadow: [
          BoxShadow(color: pModo == 1 ? Colores.segundo : Colores.primero, blurRadius: 8, offset: const Offset(4, 4)),
          BoxShadow(color: Colores.blanco, blurRadius: 4, offset: Offset(-2, -2)),
        ],
      ),
      child: Text(
        _formatearTiempo(_segundos),
        style: GoogleFonts.comicNeue(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colores.blanco,
          shadows: [
            Shadow(color: pModo == 1 ? Colores.cuarto : Colores.primero, blurRadius: 3, offset: const Offset(2, 2)),
          ],
        ),
      ),
    );
  }
}
