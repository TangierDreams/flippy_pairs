import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> widGameOver(
  BuildContext context,
  int gamePoints,
  int totalPoints,
  String time, {
  VoidCallback? onPlayAgain,
}) {
  bool won = gamePoints > 0 ? true : false;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: won
                  ? [Colors.orangeAccent, const Color(0xFFFFEB3B)]
                  : [Colors.deepPurpleAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "😅 Game Over!",
                style: GoogleFonts.luckiestGuy(
                  fontSize: 32,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 6, color: Colors.black45, offset: Offset(2, 2))],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                won
                    ? "You've won $gamePoints points in this game. Congratulations!"
                    : "You've lost $gamePoints points in this game. Oooops!",
                style: GoogleFonts.baloo2(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Your total score is $totalPoints points.",
                style: GoogleFonts.baloo2(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "You finished the game in $time minutes.",
                style: GoogleFonts.baloo2(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // NEW: Two buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Finish button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // close dialog
                      Navigator.of(context).pop(); // go back home
                    },
                    child: const Text("Finish"),
                  ),

                  // Play Again button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // close dialog
                      if (onPlayAgain != null) onPlayAgain();
                    },
                    child: const Text("Play Again"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
