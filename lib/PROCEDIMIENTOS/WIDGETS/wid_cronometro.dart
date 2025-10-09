import 'dart:async';
import 'package:flutter/material.dart';

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

  /// Inicia el cronómetro.
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

  /// Detiene (pausa) el cronómetro.
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
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blueGrey),
      ),
      child: Text(
        _tiempoEnMMSS,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Monospace',
          color: Colors.black87,
        ),
      ),
    );
  }
}
