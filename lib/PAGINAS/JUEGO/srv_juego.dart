//==============================================================================
// SERVICIO DE LÓGICA DEL JUEGO
// Lógica del juego + comunicación con base de datos
// La UI solo habla con este servicio, nunca directamente con la BD
//==============================================================================

import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/srv_cronometro.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fechas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_imagenes.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_supabase.dart';

class SrvJuego {
  //----------------------------------------------------------------------------
  // Inicilizar correctamente todas las variables que controlan el estado del
  // juego dependiendo del número de filas y columnas elegidas.
  //----------------------------------------------------------------------------
  static void crearNuevoJuego(int pFilas, int pColumnas) {
    SrvLogger.grabarLog("srv_juego", "crearNuevoJuego()", "Creando nuevo juego");

    final cartasTotales = pFilas * pColumnas;
    final parejasTotales = cartasTotales ~/ 2;

    EstadoDelJuego.filas = pFilas;
    EstadoDelJuego.columnas = pColumnas;
    EstadoDelJuego.cartasTotales = cartasTotales;
    EstadoDelJuego.parejasTotales = parejasTotales;

    //Obtenemos un conjunto aleatorio de parejas de cartas para el juego:
    EstadoDelJuego.listaDeImagenes = SrvImagenes.obtenerImagenesParaJugar(parejasTotales);

    //Creamos una lista de tamaño fijo (cartasTotales) y colocamos todos sus
    //valores a "false". Al inicio todas las cartas están boca abajo:
    EstadoDelJuego.listaDeCartasGiradas = List.filled(cartasTotales, false);

    //Creamos otra lista de tamaño fijo para las cartas emparejadas.  al
    //inicio del juego no hay ninguna emparejada. Todas a "false".
    EstadoDelJuego.listaDeCartasEmparejadas = List.filled(cartasTotales, false);

    EstadoDelJuego.procesandoTareas = false;
    EstadoDelJuego.primeraCarta = null;
    EstadoDelJuego.puntosPartida = 0;
    EstadoDelJuego.parejasAcertadas = 0;
    EstadoDelJuego.parejasFalladas = 0;
    EstadoDelJuego.cartasDestello = {};
    SrvLogger.grabarLog("srv_juego", "crearNuevoJuego()", "Nuevo juego creado.");
  }

  //----------------------------------------------------------------------------
  // Comprobar si dos cartas son iguales
  //----------------------------------------------------------------------------
  static bool sonCartasIguales(int pCarta1, int pCarta2) {
    return EstadoDelJuego.listaDeImagenes[pCarta1] == EstadoDelJuego.listaDeImagenes[pCarta2];
  }

  //----------------------------------------------------------------------------
  // Comprobar si el juego ha terminado
  //----------------------------------------------------------------------------
  static bool estaJuegoTerminado() {
    for (bool emparejada in EstadoDelJuego.listaDeCartasEmparejadas) {
      if (!emparejada) return false;
    }
    return true;
  }

  //----------------------------------------------------------------------------
  // Calcular puntos (sumar si acierto, restar si fallo)
  //----------------------------------------------------------------------------
  static int _calcularPuntos(int pPuntosActuales, bool pEsAcierto) {
    final nivel = InfoNiveles.nivel[EstadoDelJuego.nivel];

    if (pEsAcierto) {
      return pPuntosActuales + (nivel['puntosMas'] as int);
    } else {
      return pPuntosActuales - (nivel['puntosMenos'] as int);
    }
  }

  //----------------------------------------------------------------------------
  // FUNCIÓN PRINCIPAL: Procesar cuando pulsan una carta
  //----------------------------------------------------------------------------
  static void procesarCartaPulsada(int pIndex) {
    // 1. Verificar si podemos girar esta carta
    if (EstadoDelJuego.procesandoTareas ||
        EstadoDelJuego.listaDeCartasGiradas[pIndex] ||
        EstadoDelJuego.listaDeCartasEmparejadas[pIndex]) {
      ResultadoClick.accion = TipoAccion.ignorar;
      return;
    }

    // 2. Girar la carta
    EstadoDelJuego.listaDeCartasGiradas[pIndex] = true;

    // 3. ¿Es la primera o la segunda carta del turno?
    if (EstadoDelJuego.primeraCarta == null) {
      EstadoDelJuego.primeraCarta = pIndex;
      ResultadoClick.accion = TipoAccion.primeraCartaGirada;
      return;
    }

    // Es la segunda carta, comparar
    final indicePrimera = EstadoDelJuego.primeraCarta!;
    final indiceSegunda = pIndex;

    // 4. Comparar las dos cartas
    if (sonCartasIguales(indicePrimera, indiceSegunda)) {
      // ACIERTO
      EstadoDelJuego.listaDeCartasEmparejadas[indicePrimera] = true;
      EstadoDelJuego.listaDeCartasEmparejadas[indiceSegunda] = true;
      EstadoDelJuego.primeraCarta = null;
      EstadoDelJuego.parejasAcertadas++;
      EstadoDelJuego.puntosPartida = _calcularPuntos(EstadoDelJuego.puntosPartida, true);
      EstadoDelJuego.cartasDestello = {indicePrimera, indiceSegunda};

      ResultadoClick.accion = TipoAccion.parejasIguales;
      ResultadoClick.primeraCarta = indicePrimera;
      ResultadoClick.segundaCarta = indiceSegunda;
    } else {
      // FALLO
      EstadoDelJuego.primeraCarta = null;
      EstadoDelJuego.parejasFalladas++;
      EstadoDelJuego.puntosPartida = _calcularPuntos(EstadoDelJuego.puntosPartida, false);

      ResultadoClick.accion = TipoAccion.parejasDiferentes;
      ResultadoClick.primeraCarta = indicePrimera;
      ResultadoClick.segundaCarta = indiceSegunda;
    }
  }

  static void ocultarCartasFalladas(int pCarta1, int pCarta2) {
    EstadoDelJuego.listaDeCartasGiradas[pCarta1] = false;
    EstadoDelJuego.listaDeCartasGiradas[pCarta2] = false;
  }

  //----------------------------------------------------------------------------
  // Limpiar el efecto de destello
  //----------------------------------------------------------------------------
  static void limpiarDestello() {
    EstadoDelJuego.cartasDestello.clear();
  }

  //============================================================================
  // COMUNICACIÓN CON BASE DE DATOS
  //============================================================================

  //----------------------------------------------------------------------------
  // Guardar la partida en la base de datos
  //----------------------------------------------------------------------------
  static Future<void> guardarPartida() async {
    SrvLogger.grabarLog("srv_juego", "guardarPartida()", "Guardando la partida");

    await SrvSupabase.grabarPartida(
      pId: SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: '?'),
      pNivel: EstadoDelJuego.nivel,
      pNombre: SrvDiskette.leerValor(DisketteKey.deviceName, defaultValue: '?'),
      pPais: SrvDiskette.leerValor(DisketteKey.idPais, defaultValue: '?'),
      pCiudad: SrvDiskette.leerValor(DisketteKey.ciudad, defaultValue: '?'),
      pPuntos: EstadoDelJuego.puntosPartida,
      pTiempo: SrvCronometro.obtenerSegundos(),
      pIp: SrvDiskette.leerValor(DisketteKey.ip),
    );
  }

  //----------------------------------------------------------------------------
  // Obtener todos los datos necesarios para mostrar el popup de fin de juego
  //----------------------------------------------------------------------------
  static Future<void> obtenerDatosFinJuego() async {
    SrvLogger.grabarLog("srv_juego", "obtenerDatosFinJuego()", "Obteniendo datos finales");

    // Obtener datos del dispositivo
    final datosDispositivo = await SrvSupabase.obtenerRegFlippy(
      pId: SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: ''),
    );

    // Obtener posición en el ranking
    final posicionRanking = await SrvSupabase.obtenerRankingFlippy(
      pId: SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: ''),
      pLevel: EstadoDelJuego.nivel,
    );

    // Buscar el registro del nivel jugado
    final registroNivel = datosDispositivo.firstWhere(
      (reg) => reg['nivel'] == EstadoDelJuego.nivel,
      orElse: () => <String, dynamic>{},
    );

    DatosFinJuego.nombreNivel = InfoNiveles.nivel[EstadoDelJuego.nivel]['titulo'] as String;
    DatosFinJuego.puntosPartida = EstadoDelJuego.puntosPartida;
    DatosFinJuego.posicionRanking = posicionRanking;
    DatosFinJuego.puntosRecord = registroNivel['puntos'] ?? 0;
    DatosFinJuego.partidasTotales = registroNivel['partidas'] ?? 0;
    DatosFinJuego.tiempoPartida = SrvCronometro.obtenerTiempo();
    DatosFinJuego.tiempoNivel = SrvFechas.segundosAMinutosYSegundos(
      InfoNiveles.nivel[EstadoDelJuego.nivel]['tiempo'] as int,
    );
    DatosFinJuego.tiempoRecord = SrvFechas.segundosAMinutosYSegundos(registroNivel['tiempo_record'] ?? 0);
  }
}
