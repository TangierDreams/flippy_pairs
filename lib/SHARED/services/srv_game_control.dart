import 'package:flippy_pairs/SHARED/SERVICES/srv_diskette.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/SHARED/DATA/dat_icons.dart';

class SrvGameControl {
  // --- CONFIGURATION ---

  final int rows;
  final int cols;

  // --- GAME STATE ---

  late List<IconData> icons; // The actual icons on the cards
  late List<bool> cardsUp; // Tracks which cards are currently flipped face-up
  late List<bool> matched; // Tracks which cards are permanently matched

  int? firstFlippedIndex; // Index of the first card flipped in the current turn
  bool isFlipAllowed = true; // Controls if the user can tap a card (stops taps during match checking)

  // --- SCORES & RESULTS ---

  int matchedPairsCount = 0; // Total number of pairs found
  int failedPairsCount = 0; // Total number of failed attempts
  int points = 0; // Current score/points
  int gamePoints = 0; // Puntos solo de la partida actual.

  // --- FEEDBACK TO UI (The Flash Logic) ---

  bool isLastMoveAMatch = false; // Flag indicating if the last pair flip resulted in a match
  bool isLastMoveAnError = false; // Flag indicating if the last pair flip resulted in a Mogambo.

  Set<int> lastFlippedCards = {}; // Indices of the two cards involved in the last flip (for flashing)

  // --------------------------------------------------------------------------
  // --- INITIALIZATION ---
  // --------------------------------------------------------------------------

  SrvGameControl({required this.rows, required this.cols}) {
    _initializeGameSetup();
  }

  // Verbose getters for clarity (these were previously concise):
  int get totalCardsCount {
    return rows * cols;
  }

  int get requiredPairCount {
    return totalCardsCount ~/ 2;
  }

  // Getter para saber si se ha acabado la partida o no:

  bool get hasWon {
    // Miramos si todas las cartas están a true en la lista de 'matched':
    for (final isCardMatched in matched) {
      if (isCardMatched == false) {
        return false; // No todas las cartas hacen match.
      }
    }
    // Ha acabado la partida y nos guardamos la puntuacion:
    SrvDiskette.set("puntuacion", value: points);
    return true; // Todas las cartas hacen match.
  }

  // Function called by the UI to retrieve the indices for the flash animation

  Set<int> getMatchedIndicesForFlash() {
    // We return the indices and then immediately clear the set,
    // as the UI only needs them for one short duration.
    final indices = Set<int>.from(lastFlippedCards);
    lastFlippedCards.clear();
    return indices;
  }

  void _initializeGameSetup() {
    icons = DatIcons.getIcons(requiredPairCount);

    cardsUp = List.generate(totalCardsCount, (_) => false);
    matched = List.generate(totalCardsCount, (_) => false);
    firstFlippedIndex = null;
    isFlipAllowed = true;
    matchedPairsCount = 0;
    isLastMoveAMatch = false;
    isLastMoveAnError = false;
    lastFlippedCards = {};
    failedPairsCount = 0;
    gamePoints = 0;

    // Load points from disk (using a clearer default value expression)
    points = SrvDiskette.get("puntuacion", defaultValue: 0) as int;
  }

  void resetGame() {
    _initializeGameSetup();
  }

  // --------------------------------------------------------------------------
  // --- CORE GAME LOGIC ---
  // --------------------------------------------------------------------------

  /// Handles tap logic:
  /// 1. Flips cards.
  /// 2. Checks for match/mismatch.
  /// 3. Updates scores and state.
  /// Returns: true (match), false (mismatch), or null (only one card flipped).

  Future<bool?> onCardTap(int index, void Function(void Function()) setState) async {
    // --- Step 1: Pre-Checks ---

    if (isFlipAllowed == false) return null; // Wait for previous flip to resolve

    // Ignore already face-up or matched cards
    if (cardsUp[index] == true || matched[index] == true) return null;

    // --- Step 2: Flip the Card ---

    // Flip the card up and trigger a UI rebuild immediately
    setState(() {
      cardsUp[index] = true;
    });

    // --- Step 3: Check Card Count ---

    if (firstFlippedIndex == null) {
      // This is the first card of the pair
      firstFlippedIndex = index;
      isLastMoveAMatch = false; // Reset the match flag
      isLastMoveAnError = false;
      return null;
    }

    // --- Step 4: Two Cards are Flipped - Prepare Check ---

    final int firstIndex = firstFlippedIndex!;
    final int secondIndex = index;

    // Store indices for UI flashing (needs to happen before they are potentially hidden)

    lastFlippedCards.clear();
    lastFlippedCards.add(firstIndex);
    lastFlippedCards.add(secondIndex);

    // --- Step 5: Check for Match ---

    if (icons[firstIndex] == icons[secondIndex]) {
      // --- LAS CARTAS HACEN MATCH ---

      setState(() {
        // Permanently mark both cards as matched
        matched[firstIndex] = true;
        matched[secondIndex] = true;

        // Reset the flip counter for the next turn
        firstFlippedIndex = null;
      });

      isLastMoveAMatch = true;
      isLastMoveAnError = false;
      matchedPairsCount++;
      points += 10;
      gamePoints += 10;

      return true; // Return true for successful match
    } else {
      // --- LAS CARTAS ESTÁN PARA EL ORTO ---

      isFlipAllowed = false; // Block further flips until the cards are turned back down

      // Wait for the user to see the mismatch
      await Future.delayed(const Duration(milliseconds: 800));

      setState(() {
        // Flip both cards back down
        cardsUp[firstIndex] = false;
        cardsUp[secondIndex] = false;

        // Reset state to allow next flip
        firstFlippedIndex = null;
        isFlipAllowed = true;
      });

      isLastMoveAMatch = false;
      isLastMoveAnError = true;
      failedPairsCount++;
      points--;
      gamePoints--;

      return false; // Return false for mismatch
    }
  }
}
