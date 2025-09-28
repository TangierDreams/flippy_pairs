import 'package:audioplayers/audioplayers.dart';

class SrvSounds {
  static final SrvSounds _instance = SrvSounds._internal();
  factory SrvSounds() => _instance;
  SrvSounds._internal();

  // Number of simultaneous players allowed
  final int _poolSize = 8;
  late final List<AudioPlayer> _players;
  int _currentIndex = 0;

  /// Must be called once in main() before using sounds
  Future<void> init() async {
    _players = List.generate(_poolSize, (_) => AudioPlayer());
  }

  Future<void> _play(String fileName) async {
    final player = _players[_currentIndex];
    _currentIndex = (_currentIndex + 1) % _poolSize;

    await player.stop(); // reset if still playing
    await player.play(AssetSource('sounds/$fileName'));
  }

  Future<void> emitPlaySound() => _play('play.wav');
  Future<void> emitLevelSound() => _play('level.wav');
  Future<void> emitFlipSound() => _play('flip.wav');
  Future<void> emitGobackSound() => _play('goback.wav');

  void dispose() {
    for (final p in _players) {
      p.dispose();
    }
  }
}
