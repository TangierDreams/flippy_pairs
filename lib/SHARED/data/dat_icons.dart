import 'package:flutter/material.dart';
import 'dart:math';

class DatIcons {
  static final List<IconData> baseIcons = [
    Icons.star,
    Icons.favorite,
    Icons.cake,
    Icons.alarm,
    Icons.home,
    Icons.pets,
    Icons.sports_soccer,
    Icons.music_note,
    Icons.work,
    Icons.camera_alt,
    Icons.flight,
    Icons.local_cafe,
    Icons.shopping_cart,
    Icons.wifi,
    Icons.directions_car,
    Icons.phone,
  ];

  // Obtenemos un número de pares de iconos, desordenados:

  static List<IconData> getIcons(int pairCount) {
    final random = Random();

    // Cogemos los primeros n iconos de la lista base:

    final selected = baseIcons.take(pairCount).toList();

    // Los duplicamos para hacer pares:

    final allCards = [...selected, ...selected];

    // Los desordenamos:

    allCards.shuffle(random);

    return allCards;
  }
}