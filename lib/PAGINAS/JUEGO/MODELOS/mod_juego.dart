//==============================================================================
// MODELO DE DATOS DEL JUEGO
// Solo la estructura y almacenamiento de datos.
//==============================================================================

import 'dart:io';

//------------------------------------------------------------------------------
// Almacenamos información de los niveles de juego.
//------------------------------------------------------------------------------
class InfoNiveles {
  static const nivel = [
    {'titulo': '3x2', 'filas': 3, 'columnas': 2, 'puntosMas': 10, 'puntosMenos': 10, 'tiempo': 20},
    {'titulo': '4x3', 'filas': 4, 'columnas': 3, 'puntosMas': 10, 'puntosMenos': 9, 'tiempo': 45},
    {'titulo': '5x4', 'filas': 5, 'columnas': 4, 'puntosMas': 10, 'puntosMenos': 7, 'tiempo': 80},
    {'titulo': '6x5', 'filas': 6, 'columnas': 5, 'puntosMas': 10, 'puntosMenos': 6, 'tiempo': 260},
    {'titulo': '8x7', 'filas': 8, 'columnas': 7, 'puntosMas': 10, 'puntosMenos': 4, 'tiempo': 360},
    {'titulo': '9x8', 'filas': 9, 'columnas': 8, 'puntosMas': 10, 'puntosMenos': 3, 'tiempo': 460},
  ];
}

//------------------------------------------------------------------------------
// Qué puede pasar cuando se pulsa una carta
//------------------------------------------------------------------------------
enum TipoAccion {
  enEspera, //Todavía no ha pasado nada
  ignorar, // La carta ya está girada o no se puede pulsar
  primeraCartaGirada, // Se giró la primera carta del turno
  parejasIguales, // Las dos cartas son iguales (acierto)
  parejasDiferentes, // Las dos cartas son diferentes (fallo)
}

class GameSpeed {
  static List<int> memo = [1800, 900, 500];
  static List<int> destello = [1200, 800, 300];
  static List<int> giro = [500, 400, 150];
}

//------------------------------------------------------------------------------
// Almacena el estado de una partida desde el inicio hasta el final.
//------------------------------------------------------------------------------
class EstadoDelJuego {
  // Configuración del tablero (no cambian durante la partida)
  static int filas = 3;
  static int columnas = 2;
  static int nivel = 0;
  static int tema = 0;
  static String nomTema = 'retratos';
  static int cartasTotales = 0;
  static int parejasTotales = 0;
  static List<File> listaDeImagenes = [];
  static bool juegoEnCurso = false;
  static bool juegoPausado = false;
  static bool musicaActiva = false;

  // Estado que SÍ cambia durante la partida
  static List<bool> listaDeCartasGiradas = [];
  static List<bool> listaDeCartasEmparejadas = [];
  static bool procesandoTareas = false;
  static List<Function> listaDeTareas = [];
  static int? primeraCarta;
  static int puntosPartida = 0;
  static int parejasAcertadas = 0;
  static int parejasFalladas = 0;
  static Set<int> cartasDestello = {};
}

//------------------------------------------------------------------------------
// Resultado de pulsar una carta
// Le dice a la UI qué pasó para que sepa cómo reaccionar
//------------------------------------------------------------------------------
class ResultadoClick {
  static TipoAccion accion = TipoAccion.enEspera;
  static int? primeraCarta;
  static int? segundaCarta;
}

//------------------------------------------------------------------------------
// Conjunto de datos al acabar una partida para mostrar info al usuario.
//------------------------------------------------------------------------------
class DatosFinJuego {
  static String nombreNivel = "";
  static int puntosPartida = 0;
  static int posicionRanking = 0;
  static int puntosRecord = 0;
  static int partidasTotales = 0;
  static String tiempoPartida = "";
  static String tiempoNivel = "";
  static String tiempoRecord = "";
}
