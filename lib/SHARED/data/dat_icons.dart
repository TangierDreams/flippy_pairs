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
    Icons.add_moderator_sharp,
    Icons.telegram,
    Icons.sos,
    Icons.mail,
    Icons.mobile_off,
    Icons.play_circle,
    Icons.arrow_circle_left,
    Icons.arrow_circle_down,
    Icons.arrow_circle_right,
    Icons.arrow_circle_up,
    Icons.ice_skating,
    Icons.sports,
    Icons.wifi,
    Icons.wifi_calling,
    Icons.lock_clock_outlined,
    Icons.mark_chat_read_outlined,
    Icons.ac_unit,
    Icons.insert_chart,
    Icons.abc_sharp,
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