import 'package:audioplayers/audioplayers.dart';

// ============================================================================
// VARIABLES GLOBALES PARA AUDIO
// ============================================================================

const int _cantidadReproductores = 8;
late List<AudioPlayer> _reproductores;
int _indiceActual = 0;
bool _inicializado = false;

// ============================================================================
// INICIALIZACIÓN
// ============================================================================

// Inicializa el pool de reproductores de audio
// Llamar desde main.dart antes de reproducir cualquier sonido

Future<void> inicializarSonidos() async {
  if (_inicializado) return;

  _reproductores = List.generate(_cantidadReproductores, (_) => AudioPlayer());
  _inicializado = true;
}

// ============================================================================
// FUNCIONES DE REPRODUCCIÓN
// ============================================================================

/// Reproduce un archivo de sonido desde assets/sonidos/
Future<void> _reproducirSonido(String nombreArchivo) async {
  final reproductor = _reproductores[_indiceActual];
  _indiceActual = (_indiceActual + 1) % _cantidadReproductores;

  await reproductor.stop(); // Detener si aún está sonando
  await reproductor.play(AssetSource('sonidos/$nombreArchivo'));
}

/// Reproduce el sonido de play
Future<void> reproducirSonidoPlay() => _reproducirSonido('play.wav');

/// Reproduce el sonido de nivel completado
Future<void> reproducirSonidoLevel() => _reproducirSonido('level.wav');

/// Reproduce el sonido de voltear carta
Future<void> reproducirSonidoFlip() => _reproducirSonido('flip.wav');

/// Reproduce el sonido de error/retroceso
Future<void> reproducirSonidoGoback() => _reproducirSonido('goback.wav');

// ============================================================================
// LIMPIEZA
// ============================================================================

/// Libera todos los reproductores de audio
/// Llamar cuando la app se cierre o ya no necesites sonidos
void liberarSonidos() {
  for (final reproductor in _reproductores) {
    reproductor.dispose();
  }
  _inicializado = false;
}
