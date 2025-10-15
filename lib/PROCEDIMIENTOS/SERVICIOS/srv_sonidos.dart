import 'package:audioplayers/audioplayers.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';

class SrvSonidos {
  // ============================================================================
  // VARIABLES GLOBALES PARA AUDIO
  // ============================================================================

  static const int _cantidadReproductores = 8;
  static late List<AudioPlayer> _reproductorSFX;
  static int _indiceActual = 0;
  static bool _inicializado = false;

  // Reproductor dedicado para la música de fondo
  static final AudioPlayer _musicaFondoPlayer = AudioPlayer();

  // ============================================================================
  // INICIALIZACIÓN
  // ============================================================================

  // Inicializa el pool de reproductores de audio
  // Llamar desde main.dart antes de reproducir cualquier sonido

  static Future<void> inicializar() async {
    if (_inicializado) return;

    // 1. CONTEXTO PARA MÚSICA DE FONDO (Permite mezcla)
    final musicContext = AudioContext(
      android: AudioContextAndroid(
        usageType: AndroidUsageType.media,
        contentType: AndroidContentType.music,
        audioFocus: AndroidAudioFocus.gainTransientMayDuck, // Sigue permitiendo que otros lo pausen o se mezclen
      ),
    );
    await _musicaFondoPlayer.setAudioContext(musicContext);

    // 2. CONTEXTO PARA SFX (Clave: AudioFocus.none)
    // Usamos el uso 'game' pero le decimos que NO pida el enfoque de audio.
    final sfxContext = AudioContext(
      android: AudioContextAndroid(
        usageType: AndroidUsageType.game,
        contentType: AndroidContentType.sonification,
        audioFocus: AndroidAudioFocus.none, // ⬅️ ¡ESTO ES LO CLAVE PARA EVITAR LA INTERRUPCIÓN!
      ),
    );

    _reproductorSFX = List.generate(_cantidadReproductores, (index) {
      final player = AudioPlayer();
      // Aplicar el contexto de SFX a CADA reproductor del pool
      player.setAudioContext(sfxContext);
      return player;
    });

    _inicializado = true;
  }

  // ============================================================================
  // CONTROL DE MÚSICA DE FONDO (NUEVAS FUNCIONES)
  // ============================================================================

  static Future<void> iniciarMusicaFondo() async {
    if (SrvDiskette.leerValor(DisketteKey.musicaActivada)) {
      // Configura para que se repita en bucle y ajusta el volumen.
      await _musicaFondoPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicaFondoPlayer.setVolume(0.2); // Volumen bajo

      // Ruta de la música. Asumo que se llama 'musica_fondo.mp3'
      await _musicaFondoPlayer.play(AssetSource('sonidos/music.mp3'));
    }
  }

  static Future<void> detenerMusicaFondo() async {
    await _musicaFondoPlayer.stop();
  }

  // ============================================================================
  // FUNCIONES DE REPRODUCCIÓN SFX
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
    if (SrvDiskette.leerValor(DisketteKey.sonidoActivado)) {
      final reproductor = _reproductorSFX[_indiceActual];
      _indiceActual = (_indiceActual + 1) % _cantidadReproductores;
      await reproductor.stop(); // Detener si aún está sonando

      // ⚠️ IMPORTANTE: Configurar los SFX para que no interfieran con la música.
      // Usamos ReleaseMode.release para que se libere al terminar el SFX.
      await reproductor.setReleaseMode(ReleaseMode.release);

      await reproductor.play(AssetSource('sonidos/$nombreArchivo'));
    }
  }

  // ============================================================================
  // LIMPIEZA
  // ============================================================================

  // Libera todos los reproductores de audio
  // Llamar cuando la app se cierre o ya no necesites sonidos

  static void liberar() {
    // Liberar el reproductor de música de fondo
    _musicaFondoPlayer.dispose();

    for (final reproductor in _reproductorSFX) {
      reproductor.dispose();
    }
    _inicializado = false;
  }
}
