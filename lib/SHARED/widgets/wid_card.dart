import 'dart:math';
import 'package:flippy_pairs/SHARED/SERVICES/srv_sounds.dart';
import 'package:flutter/material.dart';

class WidCard extends StatelessWidget {
  final bool isFaceUp;
  final IconData frontIcon;
  final VoidCallback onTap;

  const WidCard({
    super.key,
    required this.isFaceUp,
    required this.frontIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
           SrvSounds().emitFlipSound();  // extra action
           onTap();                      // then call the passed function
        },      
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 0,
          end: isFaceUp ? 1 : 0, // 0 = back, 1 = front
        ),
        duration: const Duration(milliseconds: 500),
        //curve: Curves.easeInOutBack, // 👈 bounce curve
        builder: (context, value, child) {
          // Rotate Y axis from 0 → π
          double angle = value * pi;
          bool showFront = value > 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateY(angle),
            child: Container(
              decoration: BoxDecoration(
                //color: Colors.blueGrey[700],
                color: showFront ? const Color.fromARGB(255, 234, 238, 240) : Colors.blueGrey[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  showFront ? frontIcon : Icons.help_outline,
                  //color: Colors.white70,
                  color: showFront ? const Color.fromARGB(255, 193, 12, 12) : Colors.white70,
                  size: 32,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
