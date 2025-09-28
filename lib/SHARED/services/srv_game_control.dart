import 'package:flippy_pairs/SHARED/SERVICES/srv_diskette.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/SHARED/DATA/dat_icons.dart';

class SrvGameControl {
  final int rows;
  final int cols;
  late List<IconData> icons;
  late List<bool> cardsUp;
  late List<bool> matched;
  int? firstFlippedIndex;
  bool allowFlip = true;
  int matchedPairs = 0;
  int failedPairs = 0;
  int points = 0;

  SrvGameControl({required this.rows, required this.cols}) {
    _startNewGame();
  }

  int get totalCards => rows * cols;
  int get pairCount => totalCards ~/ 2;

  void _startNewGame() {
    icons = DatIcons.getIcons(pairCount);

    cardsUp = List.generate(totalCards, (_) => false);
    matched = List.generate(totalCards, (_) => false);
    firstFlippedIndex = null;
    allowFlip = true;
    matchedPairs = 0;
    failedPairs = 0;
    points = SrvDiskette.get("puntuacion", defaultValue: 0);
  }

  void resetGame() {
    SrvDiskette.set("puntuacion", value: points);
    _startNewGame();
  }

  bool get hasWon => matched.every((m) => m);

  /// Handles tap logic and returns a callback for UI updates
  /// If a pair was matched -> returns `true`
  /// If a pair was wrong -> returns `false`
  /// If only one card flipped -> returns `null`

  Future<bool?> onCardTap(int index, void Function(void Function()) setState) async {
    if (!allowFlip) return null;
    if (cardsUp[index] || matched[index]) return null;

    setState(() => cardsUp[index] = true);

    if (firstFlippedIndex == null) {
      firstFlippedIndex = index;
      return null;
    }

    final int firstIndex = firstFlippedIndex!;
    final int secondIndex = index;

    if (icons[firstIndex] == icons[secondIndex]) {
      setState(() {
        matched[firstIndex] = true;
        matched[secondIndex] = true;
        firstFlippedIndex = null;
      });
      matchedPairs++;
      points += 10;
      return true; // match
    } else {
      allowFlip = false;
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        cardsUp[firstIndex] = false;
        cardsUp[secondIndex] = false;
        firstFlippedIndex = null;
        allowFlip = true;
      });
      failedPairs++;
      points--;
      return false; // not a match
    }
  }
}
