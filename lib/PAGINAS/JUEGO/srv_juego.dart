//==============================================================================
// MÓDULO DE LÓGICA DEL JUEGO.
//==============================================================================

import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_juego_acabado.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_cronometro.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_imagenes.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_supabase.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fechas.dart';
import 'package:flutter/material.dart';

class SrvJuego {
  //----------------------------------------------------------------------------
  // VARIABLES GLOBALES DEL JUEGO
  //----------------------------------------------------------------------------

  // Configuración del tablero
  static late int filas;
  static late int columnas;
  static late int cartasTotales;
  static late int parejasTotales;

  // Las cartas y su estado
  static late List<String> listaDeImagenes; // Los iconos de cada carta
  static late List<bool> listaDeCartasGiradas; // true = carta boca arriba
  static late List<bool> listaDeCartasEmparejadas; // true = ya hizo match

  // Control del turno actual
  static int? _primeraCarta; // índice de la primera carta volteada
  static bool _puedoGirarLaCarta = true; // false = esperando a que se oculten las cartas

  // Puntuaciones
  static int puntosPartida = 0; // Puntos solo de esta partida
  static int parejasAcertadas = 0;
  static int parejasFalladas = 0;

  // Para el efecto visual de flash
  static Set<int> cartasDestello = {};

  static bool initCronometro = true;

  //------------------------------------------------------------------------------
  // FUNCIONES DE INICIALIZACIÓN
  //------------------------------------------------------------------------------

  static void inicializarJuego(int pFilas, int pColumnas) async {
    SrvLogger.grabarLog("srv_juego", "inicializarJuego()", "Inicializamos el juego");
    filas = pFilas;
    columnas = pColumnas;
    cartasTotales = filas * columnas;
    parejasTotales = cartasTotales ~/ 2;

    // Conseguir los iconos aleatorios
    listaDeImagenes = SrvImagenes.obtenerImagenes(parejasTotales);

    // Resetear todos los estados
    listaDeCartasGiradas = List.filled(cartasTotales, false);
    listaDeCartasEmparejadas = List.filled(cartasTotales, false);

    _primeraCarta = null;
    _puedoGirarLaCarta = true;

    parejasAcertadas = 0;
    parejasFalladas = 0;
    puntosPartida = 0;
    SrvCronometro.reset();
    initCronometro = true;
    cartasDestello = {};

    // Empezamos la música:

    SrvSonidos.iniciarMusicaFondo();
    InfoJuego.musicaActiva = true;
  }

  static void resetearJuego() {
    SrvLogger.grabarLog("srv_juego", "resetearJuego()", "Reseteamos el juego");
    inicializarJuego(filas, columnas);
  }

  static void pausarCronometro() {
    if (InfoJuego.juegoEnCurso && !InfoJuego.juegoPausado) {
      SrvCronometro.stop();
      InfoJuego.juegoPausado = true;
      SrvLogger.grabarLog("srv_juego", "pausarCronometro()", "Cronometro pausado");
    }
  }

  static void reanudarCronometro() {
    if (InfoJuego.juegoEnCurso && InfoJuego.juegoPausado) {
      SrvCronometro.start();
      InfoJuego.juegoPausado = false;
      SrvLogger.grabarLog("srv_juego", "reanudarCronometro()", "Cronometro reanudado");
    }
  }

  //------------------------------------------------------------------------------
  // FUNCIONES DE LÓGICA PURA
  //------------------------------------------------------------------------------

  // Comprobamos si 2 cartas son iguales:

  static bool esPareja(int carta1, int carta2) {
    return listaDeImagenes[carta1] == listaDeImagenes[carta2];
  }

  // Si todas las cartas están emparejadas, se acabó el juego:

  static bool juegoTerminado() {
    for (bool emparejada in listaDeCartasEmparejadas) {
      if (!emparejada) return false;
    }
    return true;
  }

  // Sumamos puntos:

  static void _sumarPuntos() {
    puntosPartida += InfoJuego.niveles[InfoJuego.nivelSeleccionado]['puntosMas'] as int;
  }

  // Restamos puntos:

  static void _restarPuntos() {
    puntosPartida -= InfoJuego.niveles[InfoJuego.nivelSeleccionado]['puntosMenos'] as int;
  }

  //------------------------------------------------------------------------------
  // FUNCIÓN PRINCIPAL: MANEJAR EL TOQUE EN UNA CARTA
  //------------------------------------------------------------------------------

  static Future<void> cartaPulsada(int index, Function pSetState) async {
    if (initCronometro) {
      initCronometro = false;
      SrvCronometro.reset();
      SrvCronometro.start();
      SrvLogger.grabarLog('srv_juego', 'cartaPulsada()', 'Cronometro reseteado e iniciado');
      InfoJuego.juegoEnCurso = true;
      InfoJuego.juegoPausado = false;
    }

    // 1. VERIFICACIONES BÁSICAS

    // Si no puedo girar, ignoro el toque
    if (!_puedoGirarLaCarta) return;

    // Si la carta ya está girada o emparejada, ignoro
    if (listaDeCartasGiradas[index] || listaDeCartasEmparejadas[index]) return;

    // 2. VOLTEAR LA CARTA
    pSetState(() {
      listaDeCartasGiradas[index] = true;
    });

    // SONIDO DE GIRAR LA CARTA

    SrvSonidos.flip();
    await Future.delayed(const Duration(milliseconds: 900));

    // 3. ¿ES LA PRIMERA O LA SEGUNDA CARTA?

    // Si es la primera carta del turno
    if (_primeraCarta == null) {
      _primeraCarta = index;
      return; // Esperamos a que volteen la segunda
    }

    // Si llegamos aquí, es la segunda carta
    int indicePrimera = _primeraCarta!;
    int indiceSegunda = index;

    // 4. COMPROBAR SI HACEN PAREJA

    if (esPareja(indicePrimera, indiceSegunda)) {
      //-------------------------
      // LAS 2 CARTAS SON IGUALES
      //-------------------------

      pSetState(() {
        listaDeCartasEmparejadas[indicePrimera] = true;
        listaDeCartasEmparejadas[indiceSegunda] = true;
        _primeraCarta = null;
      });

      parejasAcertadas++;
      _sumarPuntos();

      // Efecto visual de parpadeo
      pSetState(() {
        cartasDestello.add(indicePrimera);
        cartasDestello.add(indiceSegunda);
      });

      // Emitimos sonido de acierto y 'destello':
      SrvSonidos.level();
      await Future.delayed(const Duration(milliseconds: 900));

      pSetState(() {
        cartasDestello.clear();
      });

      // Verificar si hemos terminado el juego
      if (juegoTerminado()) {
        SrvSonidos.detenerMusicaFondo();
        InfoJuego.musicaActiva = false;
      }
    } else {
      //----------------------------
      // LAS 2 CARTAS SON DIFERENTES
      //----------------------------

      _puedoGirarLaCarta = false; // Bloqueamos más toques
      parejasFalladas++;
      _restarPuntos();

      // Esperamos para que el jugador las vea las cartas desparejadas:

      await Future.delayed(const Duration(milliseconds: 900));

      SrvSonidos.goback();

      // Las volvemos a ocultar
      pSetState(() {
        listaDeCartasGiradas[indicePrimera] = false;
        listaDeCartasGiradas[indiceSegunda] = false;
        _primeraCarta = null;
        _puedoGirarLaCarta = true;
      });
    }
  }

  //----------------------------------------------------------------------------
  // Función para controlar si el juego ha acabado o no.
  //----------------------------------------------------------------------------

  static Future<void> controlJuegoAcabado(BuildContext pContexto, Function pSetState) async {
    if (juegoTerminado()) {
      SrvLogger.grabarLog("srv_juego", "controlJuegoAcabado()", "Juego acabado. Stop cronometro");
      SrvCronometro.stop();
      initCronometro = true;
      InfoJuego.juegoEnCurso = false;
      InfoJuego.juegoPausado = false;

      // Anotamos el resultado en Supabase:

      SrvSupabase.grabarPartida(
        pId: SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: '?'),
        pNivel: InfoJuego.nivelSeleccionado,
        pNombre: SrvDiskette.leerValor(DisketteKey.deviceName, defaultValue: '?'),
        pPais: SrvDiskette.leerValor(DisketteKey.idPais, defaultValue: '?'),
        pCiudad: SrvDiskette.leerValor(DisketteKey.ciudad, defaultValue: '?'),
        pPuntos: puntosPartida,
        pTiempo: SrvCronometro.obtenerSegundos(),
        pGanada: puntosPartida > 0 ? true : false,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      // Recogemos los resultados del usuario:

      final datosDispositivo = await SrvSupabase.obtenerRegFlippy(
        pId: SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: ''),
      );

      // Obtenemos la posición del usuario en el ranking Flippy:

      final posicionFlippy = await SrvSupabase.obtenerRankingFlippy(
        pId: SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: ''),
        pLevel: InfoJuego.nivelSeleccionado,
      );

      final nivelJugado = InfoJuego.niveles[InfoJuego.nivelSeleccionado]['titulo'] as String;

      // Busca el registro del nivel que se ha jugado:

      final registroNivel = datosDispositivo.firstWhere(
        (reg) => reg['nivel'] == InfoJuego.nivelSeleccionado,
        orElse: () => <String, dynamic>{},
      );

      if (pContexto.mounted) {
        SrvLogger.grabarLog("srv_juego", "controlJuegoAcabado()", "Mostramos el popup de final de partida");
        widJuegoAcabado(
          pContexto,
          nivelJugado,
          puntosPartida,
          posicionFlippy,
          registroNivel['puntos'],
          registroNivel['partidas'],
          SrvCronometro.obtenerTiempo(),
          SrvFechas.segundosAMinutosYSegundos(InfoJuego.niveles[InfoJuego.nivelSeleccionado]['tiempo'] as int),
          SrvFechas.segundosAMinutosYSegundos(registroNivel['tiempo_record']),
          pFuncionDeCallback: () {
            pSetState(() {
              resetearJuego();
            });
          },
        );
      } else {
        SrvLogger.grabarLog("srv_juego", "controlJuegoAcabado()", "No se encuentra el contexto");
      }
    }
  }
}
