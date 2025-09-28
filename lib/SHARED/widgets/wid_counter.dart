import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidCounter extends StatelessWidget {
  final String text;
  final int counter;
  final int mode;

  const WidCounter({super.key, required this.counter, required this.text, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: mode == 1 ? Colors.orange[300] : const Color.fromARGB(255, 169, 239, 252),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: mode == 1 ? Colors.orange[800]! : const Color.fromARGB(255, 38, 23, 253), width: 3),
        boxShadow: [
          BoxShadow(
            color: mode == 1 ? Colors.orange[900]! : const Color.fromARGB(255, 38, 23, 253),
            blurRadius: 8,
            offset: const Offset(4, 4),
          ),
          const BoxShadow(color: Colors.white70, blurRadius: 4, offset: Offset(-2, -2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: GoogleFonts.comicNeue(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: mode == 1 ? Colors.orange[900]! : const Color.fromARGB(255, 38, 23, 253),
                  blurRadius: 3,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
          Text(
            "$counter${mode == 1 ? '\u200B' : '\u200C'}",
            style: GoogleFonts.comicNeue(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: mode == 1 ? Colors.orange[900]! : const Color.fromARGB(255, 38, 23, 253),
                  blurRadius: 3,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
