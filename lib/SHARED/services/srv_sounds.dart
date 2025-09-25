import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class SrvSounds {
  static final SrvSounds _instance = SrvSounds._internal();
  factory SrvSounds() => _instance;
  SrvSounds._internal();

  final _soLoud = SoLoud.instance;

  late AudioSource playSound;
  late AudioSource levelSound;
  late AudioSource flipSound;
  late AudioSource gobackSound;

  Future<void> init() async {
    await _soLoud.init();

    // Load all sounds at startup

    try {
      playSound = await _soLoud.loadAsset('assets/sounds/play.wav');
    } catch (e) {
      debugPrint("❌ Failed to load level sound: $e");
    }

    try {
      levelSound = await _soLoud.loadAsset('assets/sounds/level.wav');
    } catch (e) {
      debugPrint("❌ Failed to load level sound: $e");
    }

    try {
      flipSound = await _soLoud.loadAsset('assets/sounds/flip.wav');
    } catch (e) {
      debugPrint("❌ Failed to load flip sound: $e");
    }

    try {
      gobackSound = await _soLoud.loadAsset('assets/sounds/goback.wav');
    } catch (e) {
      debugPrint("❌ Failed to load goBack sound: $e");
    }
  }

  void emitPlaySound() => _soLoud.play(playSound);
  void emitLevelSound() => _soLoud.play(levelSound);
  void emitFlipSound() => _soLoud.play(flipSound);
  void emitGobackSound() => _soLoud.play(gobackSound);

  void dispose() => _soLoud.deinit();
}
