import 'dart:async';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --------------------------------------------------------------------------
// CLASE PRINCIPAL DEL WIDGET (Punto de entrada)
// --------------------------------------------------------------------------

class WidCronometro extends StatefulWidget {
  const WidCronometro({super.key});

  @override
  State<WidCronometro> createState() => WidCronometroState();
}

// --------------------------------------------------------------------------
// CLASE DE ESTADO PÚBLICA (Contiene la lógica procedural y las funciones de
// control)
// --------------------------------------------------------------------------

class WidCronometroState extends State<WidCronometro> {
  // 1. VARIABLES DE ESTADO Y CONTROL

  final Stopwatch _cronometro = Stopwatch();
  Timer? _timer;
  String _tiempoEnMMSS = "00:00"; // Inicialización en 00:00 por defecto.

  // ------------------------------------------------------------------------
  // 2. FUNCIÓN AUXILIAR PROCEDURAL
  // ------------------------------------------------------------------------

  // Formatea la duración transcurrida del cronómetro a la cadena MM:SS.

  String _formatearTiempoEnMMSS(Duration duration) {
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  /// Función principal de 'tick' que actualiza la interfaz.
  void _actualizarTiempo(Timer timer) {
    setState(() {
      _tiempoEnMMSS = _formatearTiempoEnMMSS(_cronometro.elapsed);
    });
  }

  // ------------------------------------------------------------------------
  // 3. FUNCIONES DE CONTROL PÚBLICAS (Llamadas por el componente padre)
  // ------------------------------------------------------------------------

  // Inicia el cronómetro.

  void start() {
    if (_cronometro.isRunning) return;

    _timer?.cancel();
    _cronometro.start();

    // Iniciamos la actualización del UI cada 100ms.
    _timer = Timer.periodic(const Duration(milliseconds: 100), _actualizarTiempo);

    // Forzamos la primera actualización visual.
    setState(() {
      _tiempoEnMMSS = _formatearTiempoEnMMSS(_cronometro.elapsed);
    });
  }

  // Detiene el cronómetro.

  void stop() {
    _timer?.cancel();
    _cronometro.stop();

    setState(() {
      _tiempoEnMMSS = _formatearTiempoEnMMSS(_cronometro.elapsed);
    });
  }

  // Reinicia el cronómetro a cero.

  void reset() {
    _timer?.cancel();
    _cronometro.stop();
    _cronometro.reset();
    _timer = null;

    setState(() {
      _tiempoEnMMSS = _formatearTiempoEnMMSS(_cronometro.elapsed);
    });
  }

  // Devuelve los minutos y segundos que tiene en el momento de la consulta.

  String obtenerTiempo() {
    return _formatearTiempoEnMMSS(_cronometro.elapsed);
  }

  // ------------------------------------------------------------------------
  // 4. CICLO DE VIDA Y UI
  // ------------------------------------------------------------------------

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // La UI es un Container simple con el texto en formato MM:SS.
    return Container(
      width: 70,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colores.quinto,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colores.primero, width: 3),
        boxShadow: [
          BoxShadow(color: Colores.primero, blurRadius: 8, offset: const Offset(4, 4)),
          BoxShadow(color: Colores.blanco, blurRadius: 4, offset: Offset(-2, -2)),
        ],
      ),
      child: Text(
        _tiempoEnMMSS,
        style: GoogleFonts.comicNeue(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colores.blanco,
          shadows: [Shadow(color: Colores.primero, blurRadius: 3, offset: const Offset(2, 2))],
        ),
      ),
    );
  }
}
