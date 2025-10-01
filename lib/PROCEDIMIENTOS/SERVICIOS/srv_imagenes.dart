//import 'package:flutter/material.dart';
import 'dart:math';

class SrvImagenes {
  static final List<String> listaIconos = [
    "assets/imagenes/iconos/01.png",
    "assets/imagenes/iconos/02.png",
    "assets/imagenes/iconos/03.png",
    "assets/imagenes/iconos/04.png",
    "assets/imagenes/iconos/05.png",
    "assets/imagenes/iconos/06.png",
    "assets/imagenes/iconos/07.png",
    "assets/imagenes/iconos/08.png",
    "assets/imagenes/iconos/09.png",
    "assets/imagenes/iconos/10.png",
    "assets/imagenes/iconos/11.png",
    "assets/imagenes/iconos/12.png",
    "assets/imagenes/iconos/13.png",
    "assets/imagenes/iconos/14.png",
    "assets/imagenes/iconos/15.png",
    "assets/imagenes/iconos/16.png",
    "assets/imagenes/iconos/17.png",
    "assets/imagenes/iconos/18.png",
    "assets/imagenes/iconos/19.png",
    "assets/imagenes/iconos/20.png",
    "assets/imagenes/iconos/21.png",
    "assets/imagenes/iconos/22.png",
    "assets/imagenes/iconos/23.png",
    "assets/imagenes/iconos/24.png",
    "assets/imagenes/iconos/25.png",
    "assets/imagenes/iconos/26.png",
    "assets/imagenes/iconos/27.png",
    "assets/imagenes/iconos/28.png",
    "assets/imagenes/iconos/29.png",
    "assets/imagenes/iconos/30.png",
    "assets/imagenes/iconos/31.png",
    "assets/imagenes/iconos/32.png",
    "assets/imagenes/iconos/33.png",
    "assets/imagenes/iconos/34.png",
    "assets/imagenes/iconos/35.png",
    "assets/imagenes/iconos/36.png",
  ];

  static final List<String> listaAnimales = [
    "assets/imagenes/animales/01.png",
    "assets/imagenes/animales/02.png",
    "assets/imagenes/animales/03.png",
    "assets/imagenes/animales/04.png",
    "assets/imagenes/animales/05.png",
    "assets/imagenes/animales/06.png",
    "assets/imagenes/animales/07.png",
    "assets/imagenes/animales/08.png",
    "assets/imagenes/animales/09.png",
    "assets/imagenes/animales/10.png",
    "assets/imagenes/animales/11.png",
    "assets/imagenes/animales/12.png",
    "assets/imagenes/animales/13.png",
    "assets/imagenes/animales/14.png",
    "assets/imagenes/animales/15.png",
    "assets/imagenes/animales/16.png",
    "assets/imagenes/animales/17.png",
    "assets/imagenes/animales/18.png",
    "assets/imagenes/animales/19.png",
    "assets/imagenes/animales/20.png",
    "assets/imagenes/animales/21.png",
    "assets/imagenes/animales/22.png",
    "assets/imagenes/animales/23.png",
    "assets/imagenes/animales/24.png",
    "assets/imagenes/animales/25.png",
    "assets/imagenes/animales/26.png",
    "assets/imagenes/animales/27.png",
    "assets/imagenes/animales/28.png",
    "assets/imagenes/animales/29.png",
    "assets/imagenes/animales/30.png",
    "assets/imagenes/animales/31.png",
    "assets/imagenes/animales/32.png",
    "assets/imagenes/animales/33.png",
    "assets/imagenes/animales/34.png",
    "assets/imagenes/animales/35.png",
    "assets/imagenes/animales/36.png",
  ];

  static final List<String> listaPaisajes = [
    "assets/imagenes/paisajes/01.jpg",
    "assets/imagenes/paisajes/02.jpg",
    "assets/imagenes/paisajes/03.jpg",
    "assets/imagenes/paisajes/04.jpg",
    "assets/imagenes/paisajes/05.jpg",
    "assets/imagenes/paisajes/06.jpg",
    "assets/imagenes/paisajes/07.jpg",
    "assets/imagenes/paisajes/08.jpg",
    "assets/imagenes/paisajes/09.jpg",
    "assets/imagenes/paisajes/10.jpg",
    "assets/imagenes/paisajes/11.jpg",
    "assets/imagenes/paisajes/12.jpg",
    "assets/imagenes/paisajes/13.jpg",
    "assets/imagenes/paisajes/14.jpg",
    "assets/imagenes/paisajes/15.jpg",
    "assets/imagenes/paisajes/16.jpg",
    "assets/imagenes/paisajes/17.jpg",
    "assets/imagenes/paisajes/18.jpg",
    "assets/imagenes/paisajes/19.jpg",
    "assets/imagenes/paisajes/20.jpg",
    "assets/imagenes/paisajes/21.jpg",
    "assets/imagenes/paisajes/22.jpg",
    "assets/imagenes/paisajes/23.jpg",
    "assets/imagenes/paisajes/24.jpg",
    "assets/imagenes/paisajes/25.jpg",
    "assets/imagenes/paisajes/26.jpg",
    "assets/imagenes/paisajes/27.jpg",
    "assets/imagenes/paisajes/28.jpg",
    "assets/imagenes/paisajes/29.jpg",
    "assets/imagenes/paisajes/30.jpg",
    "assets/imagenes/paisajes/31.jpg",
    "assets/imagenes/paisajes/32.jpg",
    "assets/imagenes/paisajes/33.jpg",
    "assets/imagenes/paisajes/34.jpg",
    "assets/imagenes/paisajes/35.jpg",
    "assets/imagenes/paisajes/36.jpg",
  ];

  // Obtenemos un número de pares de iconos, desordenados:

  static List<String> obtenerImagenes(String pLista, int pNumParejas) {
    final random = Random();

    // Cogemos los primeros n iconos de la lista base:

    List<String> seleccionados = [];
    switch (pLista) {
      case "animales":
        seleccionados = listaAnimales.take(pNumParejas).toList();
        break;
      case "paisajes":
        seleccionados = listaPaisajes.take(pNumParejas).toList();
        break;
      default:
        seleccionados = listaIconos.take(pNumParejas).toList();
    }

    // Los duplicamos para hacer pares:

    final duplicados = [...seleccionados, ...seleccionados];

    // Los desordenamos:

    duplicados.shuffle(random);

    return duplicados;
  }
}
