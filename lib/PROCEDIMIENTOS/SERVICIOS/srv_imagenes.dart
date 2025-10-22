//import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class SrvImagenes {
  //Rutas a las imágenes:

  static const List<String> _categoriasRutas = [
    'flippy/animales',
    'flippy/coches',
    'flippy/logos',
    'flippy/retratos',
    'flippy/iconos',
    'flippy/herramientas',
  ];

  static final Map<String, List<String>> _urlsPorRuta = {};

  //----------------------------------------------------------------------------
  // Generamos las urls a cada una de las imagenes que hay en Supabase
  //----------------------------------------------------------------------------

  static void _generarUrls() {
    // Para cada una de las carpetas de imagenes:
    for (final categoriaRuta in _categoriasRutas) {
      List<String> urls = [];
      // Generamos las urls de los archivos de esta carpeta:
      for (int i = 1; i <= 36; i++) {
        final fileName = i.toString().padLeft(2, '0');
        final fullPath = '$categoriaRuta/$fileName.png';
        final String publicUrl = supabase.storage.from("others").getPublicUrl(fullPath);
        urls.add(publicUrl);
      }
      _urlsPorRuta[categoriaRuta] = urls;
    }
  }

  //----------------------------------------------------------------------------
  // Precargamos las imagenes en la caché de Flutter
  //----------------------------------------------------------------------------

  static Future<void> precargarImagenes(BuildContext context) async {
    if (_urlsPorRuta.isEmpty) {
      _generarUrls();
    }

    List<Future> precargaFutures = [];
    _urlsPorRuta.forEach((ruta, urls) {
      for (final url in urls) {
        final imageProvider = NetworkImage(url);
        // precacheImage descarga la imagen y la almacena en la caché de Flutter
        precargaFutures.add(precacheImage(imageProvider, context));
      }
    });
    await Future.wait(precargaFutures);
  }

  //----------------------------------------------------------------------------
  // Obtenemos todas las urls de una determinada categoría
  //----------------------------------------------------------------------------

  static List<String> obtenerListaUrls(String nombreCategoria) {
    // Mapea el nombre simple a la clave del mapa: 'animales' -> 'flippy/animales'
    final baseKey = 'flippy/$nombreCategoria';

    // Asume que _urlsPorRuta ya fue llenado por precargarTodasLasImagenes()
    final List<String>? listaUrls = _urlsPorRuta[baseKey];

    if (listaUrls == null || listaUrls.isEmpty) {
      // Este error nunca debería ocurrir si la precarga se completó con éxito
      throw Exception('Error: Lista de URLs no cargada para "$nombreCategoria".');
    }
    return listaUrls;
  }

  //----------------------------------------------------------------------------
  // Obtenemos un conjunto de imagenes para el juego.
  //----------------------------------------------------------------------------

  static List<String> obtenerImagenes(int pNumParejas) {
    final random = Random();
    const int totalCartas = 36;

    // Empezamos a coger cartas desde un punto aleatorio:

    int startIndex = 0;
    if (pNumParejas < totalCartas) {
      int maxStartIndex = totalCartas - pNumParejas;
      startIndex = random.nextInt(maxStartIndex + 1);
    }

    // Obtenemos todas las url's de la lista seleccionada:

    List<String> listaBase;
    try {
      listaBase = obtenerListaUrls(InfoJuego.listaSeleccionada);
    } catch (e) {
      return [];
    }

    // A partir de la lista base, cogemos solo el número de imagenes que necesitamos:

    List<String> seleccionados = listaBase.sublist(startIndex, startIndex + pNumParejas).toList();

    // Los duplicamos para formasr las parejas:

    final duplicados = [...seleccionados, ...seleccionados];

    // Los desordenamos:

    duplicados.shuffle(random);
    return duplicados;
  }
}  



  // Obtenemos un número de pares de iconos, desordenados:

  // static List<String> obtenerImagenes(int pNumParejas) {
  //   final random = Random();
  //   const int totalCartas = 36;

  //   // Miramos en qué punto de la lista podemos comenzar a coger cartas:

  //   int startIndex = 0;
  //   if (pNumParejas < totalCartas) {
  //     int maxStartIndex = totalCartas - pNumParejas;
  //     startIndex = random.nextInt(maxStartIndex + 1);
  //   }

  //   // Cogemos los primeros n iconos de la lista base:

  //   List<String> seleccionados = [];
  //   switch (InfoJuego.listaSeleccionada) {
  //     case 'animales':
  //       seleccionados = listaAnimales.sublist(startIndex, startIndex + pNumParejas).toList();
  //       break;
  //     case 'retratos':
  //       seleccionados = listaRetratos.sublist(startIndex, startIndex + pNumParejas).toList();
  //       break;
  //     case 'herramientas':
  //       seleccionados = listaHerramientas.sublist(startIndex, startIndex + pNumParejas).toList();
  //       break;
  //     case 'coches':
  //       seleccionados = listaCoches.sublist(startIndex, startIndex + pNumParejas).toList();
  //       break;
  //     case 'logos':
  //       seleccionados = listaLogos.sublist(startIndex, startIndex + pNumParejas).toList();
  //       break;
  //     default:
  //       seleccionados = listaIconos.sublist(startIndex, startIndex + pNumParejas).toList();
  //   }

  //   // Los duplicamos para hacer pares:

  //   final duplicados = [...seleccionados, ...seleccionados];

  //   // Los desordenamos:

  //   duplicados.shuffle(random);

  //   return duplicados;
  // }

