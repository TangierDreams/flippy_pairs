import 'dart:async';
import 'package:flutter/foundation.dart';

class SrvCronometro {
  // 1. STATE MANAGEMENT: All fields must be static.
  // We make the ValueNotifier static.
  static final ValueNotifier<String> tiempoEnMMSS = ValueNotifier<String>('00:00');

  // 2. INTERNAL STATE AND CONTROL: All fields must be static.
  static final Stopwatch _cronometro = Stopwatch();
  static Timer? _timer;

  // Private constructor to prevent instantiation, making it a pure utility class.
  SrvCronometro._();

  // ------------------------------------------------------------------------
  // 3. FUNCTIONS: All methods must be static.
  // ------------------------------------------------------------------------

  // Formatea la duración transcurrida del cronómetro a la cadena MM:SS.
  static String _formatearTiempoEnMMSS(Duration duration) {
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  /// Función principal de 'tick' que actualiza la interfaz.
  static void _actualizarTiempo(Timer timer) {
    // Access the static ValueNotifier directly.
    tiempoEnMMSS.value = _formatearTiempoEnMMSS(_cronometro.elapsed);
  }

  // Inicia el cronómetro.
  static void start() {
    if (_cronometro.isRunning) return;

    _timer?.cancel();
    _cronometro.start();

    _timer = Timer.periodic(const Duration(milliseconds: 100), _actualizarTiempo);

    tiempoEnMMSS.value = _formatearTiempoEnMMSS(_cronometro.elapsed);
  }

  // Detiene el cronómetro.
  static void stop() {
    _timer?.cancel();
    _cronometro.stop();
    tiempoEnMMSS.value = _formatearTiempoEnMMSS(_cronometro.elapsed);
  }

  // Reinicia el cronómetro a cero.
  static void reset() {
    _timer?.cancel();
    _cronometro.stop();
    _cronometro.reset();
    _timer = null;
    tiempoEnMMSS.value = '00:00';
  }

  // Devuelve los minutos y segundos que tiene en el momento de la consulta.
  static String obtenerTiempo() {
    return _formatearTiempoEnMMSS(_cronometro.elapsed);
  }

  static int obtenerSegundos() {
    return _cronometro.elapsed.inSeconds;
  }
}
