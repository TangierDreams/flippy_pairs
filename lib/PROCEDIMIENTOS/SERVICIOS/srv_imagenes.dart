//import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';

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

  static final List<String> listaRetratos = [
    "assets/imagenes/retratos/01.png",
    "assets/imagenes/retratos/02.png",
    "assets/imagenes/retratos/03.png",
    "assets/imagenes/retratos/04.png",
    "assets/imagenes/retratos/05.png",
    "assets/imagenes/retratos/06.png",
    "assets/imagenes/retratos/07.png",
    "assets/imagenes/retratos/08.png",
    "assets/imagenes/retratos/09.png",
    "assets/imagenes/retratos/10.png",
    "assets/imagenes/retratos/11.png",
    "assets/imagenes/retratos/12.png",
    "assets/imagenes/retratos/13.png",
    "assets/imagenes/retratos/14.png",
    "assets/imagenes/retratos/15.png",
    "assets/imagenes/retratos/16.png",
    "assets/imagenes/retratos/17.png",
    "assets/imagenes/retratos/18.png",
    "assets/imagenes/retratos/19.png",
    "assets/imagenes/retratos/20.png",
    "assets/imagenes/retratos/21.png",
    "assets/imagenes/retratos/22.png",
    "assets/imagenes/retratos/23.png",
    "assets/imagenes/retratos/24.png",
    "assets/imagenes/retratos/25.png",
    "assets/imagenes/retratos/26.png",
    "assets/imagenes/retratos/27.png",
    "assets/imagenes/retratos/28.png",
    "assets/imagenes/retratos/29.png",
    "assets/imagenes/retratos/30.png",
    "assets/imagenes/retratos/31.png",
    "assets/imagenes/retratos/32.png",
    "assets/imagenes/retratos/33.png",
    "assets/imagenes/retratos/34.png",
    "assets/imagenes/retratos/35.png",
    "assets/imagenes/retratos/36.png",
  ];

  // Obtenemos un número de pares de iconos, desordenados:

  static List<String> obtenerImagenes(int pNumParejas) {
    final random = Random();

    // Cogemos los primeros n iconos de la lista base:

    List<String> seleccionados = [];
    switch (InfoJuego.listaSeleccionada) {
      case "animales":
        seleccionados = listaAnimales.take(pNumParejas).toList();
        break;
      case "retratos":
        seleccionados = listaRetratos.take(pNumParejas).toList();
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
