//==============================================================================
// MODELO DE DATOS DEL JUEGO
// Contiene únicamente la estructura de datos, sin lógica
//==============================================================================

import 'dart:io';

//------------------------------------------------------------------------------
// Representa el estado completo del juego en un momento dado
//------------------------------------------------------------------------------
class EstadoJuego {
  // Configuración del tablero
  final int filas;
  final int columnas;
  final int cartasTotales;
  final int parejasTotales;

  // Estado de las cartas
  final List<File> listaDeImagenes;
  final List<bool> listaDeCartasGiradas;
  final List<bool> listaDeCartasEmparejadas;

  // Control del turno
  final int? primeraCarta;
  final bool puedoGirarCarta;

  // Puntuaciones
  final int puntosPartida;
  final int parejasAcertadas;
  final int parejasFalladas;

  // Efectos visuales
  final Set<int> cartasDestello;

  EstadoJuego({
    required this.filas,
    required this.columnas,
    required this.cartasTotales,
    required this.parejasTotales,
    required this.listaDeImagenes,
    required this.listaDeCartasGiradas,
    required this.listaDeCartasEmparejadas,
    required this.primeraCarta,
    required this.puedoGirarCarta,
    required this.puntosPartida,
    required this.parejasAcertadas,
    required this.parejasFalladas,
    required this.cartasDestello,
  });

  /// Crea una copia del estado con los cambios especificados
  // EstadoJuego copiarCon({
  //   int? filas,
  //   int? columnas,
  //   int? cartasTotales,
  //   int? parejasTotales,
  //   List<File>? listaDeImagenes,
  //   List<bool>? listaDeCartasGiradas,
  //   List<bool>? listaDeCartasEmparejadas,
  //   int? primeraCarta,
  //   bool? primerCartaNula,
  //   bool? puedoGirarCarta,
  //   int? puntosPartida,
  //   int? parejasAcertadas,
  //   int? parejasFalladas,
  //   Set<int>? cartasDestello,
  // }) {
  //   return EstadoJuego(
  //     filas: filas ?? this.filas,
  //     columnas: columnas ?? this.columnas,
  //     cartasTotales: cartasTotales ?? this.cartasTotales,
  //     parejasTotales: parejasTotales ?? this.parejasTotales,
  //     listaDeImagenes: listaDeImagenes ?? this.listaDeImagenes,
  //     listaDeCartasGiradas: listaDeCartasGiradas ?? List.from(this.listaDeCartasGiradas),
  //     listaDeCartasEmparejadas: listaDeCartasEmparejadas ?? List.from(this.listaDeCartasEmparejadas),
  //     primeraCarta: primerCartaNula == true ? null : (primeraCarta ?? this.primeraCarta),
  //     puedoGirarCarta: puedoGirarCarta ?? this.puedoGirarCarta,
  //     puntosPartida: puntosPartida ?? this.puntosPartida,
  //     parejasAcertadas: parejasAcertadas ?? this.parejasAcertadas,
  //     parejasFalladas: parejasFalladas ?? this.parejasFalladas,
  //     cartasDestello: cartasDestello ?? Set.from(this.cartasDestello),
  //   );
  // }
}

//------------------------------------------------------------------------------
// Resultado de procesar una carta pulsada
//------------------------------------------------------------------------------

class ResultadoCartaPulsada {
  final EstadoJuego nuevoEstado;
  final TipoAccion accion;
  final int? indicePrimera;
  final int? indiceSegunda;

  ResultadoCartaPulsada({required this.nuevoEstado, required this.accion, this.indicePrimera, this.indiceSegunda});
}

//------------------------------------------------------------------------------
// Tipos de acciones que pueden ocurrir al pulsar una carta
//------------------------------------------------------------------------------

enum TipoAccion {
  ignorar, // La carta ya está girada o no se puede girar
  primeraCartaGirada, // Se giró la primera carta del turno
  parejasIguales, // Las dos cartas son iguales (acierto)
  parejasDiferentes, // Las dos cartas son diferentes (fallo)
}
