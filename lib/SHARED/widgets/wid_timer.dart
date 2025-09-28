import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidTimer extends StatefulWidget {
  final int mode; // keep same "orange/blue" style as WidCounter

  const WidTimer({super.key, required this.mode});

  @override
  State<WidTimer> createState() => WidTimerState();
}

class WidTimerState extends State<WidTimer> {
  late Timer _timer;
  int _seconds = 0;
  bool _running = false;

  @override
  void dispose() {
    if (_running) {
      _timer.cancel();
    }
    super.dispose();
  }

  void start() {
    if (_running) return;
    _running = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _seconds++;
      });
    });
  }

  void stop() {
    if (!_running) return;
    _timer.cancel();
    _running = false;
  }

  void reset() {
    stop();
    setState(() {
      _seconds = 0;
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.mode;
    return Container(
      width: 70,
      alignment: Alignment.center,
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
      child: Text(
        _formatTime(_seconds),
        style: GoogleFonts.comicNeue(
          fontSize: 16,
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
    );
  }
}
