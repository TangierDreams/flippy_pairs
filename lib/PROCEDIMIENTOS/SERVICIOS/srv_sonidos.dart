import 'package:audioplayers/audioplayers.dart';

class SrvSonidos {
  // ============================================================================
  // VARIABLES GLOBALES PARA AUDIO
  // ============================================================================

  static const int _cantidadReproductores = 8;
  static late List<AudioPlayer> _reproductores;
  static int _indiceActual = 0;
  static bool _inicializado = false;

  // ============================================================================
  // INICIALIZACIÓN
  // ============================================================================

  // Inicializa el pool de reproductores de audio
  // Llamar desde main.dart antes de reproducir cualquier sonido

  static Future<void> inicializar() async {
    if (_inicializado) return;
    _reproductores = List.generate(_cantidadReproductores, (_) => AudioPlayer());
    _inicializado = true;
  }

  // ============================================================================
  // FUNCIONES DE REPRODUCCIÓN
  // ============================================================================

  // Reproduce el sonido de play

  static Future<void> play() => _reproducirSonido('play.wav');

  // Reproduce el sonido de nivel completado

  static Future<void> level() => _reproducirSonido('level.wav');

  // Reproduce el sonido de voltear carta

  static Future<void> flip() => _reproducirSonido('flip.wav');

  // Reproduce el sonido de error/retroceso

  static Future<void> goback() => _reproducirSonido('goback.wav');

  // Reproduce el sonido de éxito:

  static Future<void> sucess() => _reproducirSonido('success.wav');

  // Reproduce el sonido de error:

  static Future<void> error() => _reproducirSonido('error.wav');

  // Reproduce un archivo de sonido desde assets/sonidos/

  static Future<void> _reproducirSonido(String nombreArchivo) async {
    final reproductor = _reproductores[_indiceActual];
    _indiceActual = (_indiceActual + 1) % _cantidadReproductores;

    await reproductor.stop(); // Detener si aún está sonando
    await reproductor.play(AssetSource('sonidos/$nombreArchivo'));
  }

  // ============================================================================
  // LIMPIEZA
  // ============================================================================

  // Libera todos los reproductores de audio
  // Llamar cuando la app se cierre o ya no necesites sonidos

  static void liberar() {
    for (final reproductor in _reproductores) {
      reproductor.dispose();
    }
    _inicializado = false;
  }
}
