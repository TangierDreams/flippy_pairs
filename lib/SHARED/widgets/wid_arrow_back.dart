import 'package:flutter/material.dart';

class WidArrowBack extends StatelessWidget {
  const WidArrowBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.orange[400],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange[800]!, width: 3),
        boxShadow: [
          BoxShadow(color: Colors.orange[900]!, blurRadius: 10, offset: const Offset(4, 4), spreadRadius: 1),
          BoxShadow(color: const Color.fromARGB(255, 94, 124, 223), blurRadius: 5, offset: const Offset(-3, -3)),
        ],
        gradient: LinearGradient(
          colors: [Colors.orange[500]!, Colors.orange[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Efecto de highlight
          Positioned(
            top: 4,
            left: 4,
            child: SizedBox(
              width: 12,
              height: 12,
              // decoration: BoxDecoration(
              //   color: const Color.fromARGB(255, 201, 50, 50),
              //   borderRadius: BorderRadius.circular(6),
              // ),
            ),
          ),
          // Flecha extra gruesa
          Center(
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
              weight: 1000, // Máximo grosor
              shadows: [Shadow(color: Colors.orange[800]!, blurRadius: 4, offset: const Offset(2, 2))],
            ),
          ),
        ],
      ),
    );
  }
}
