//==============================================================================
// MÓDULO DE LÓGICA DEL JUEGO.
//==============================================================================

import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_juego_acabado.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_temporizador.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fechas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_imagenes.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_supabase.dart';
import 'package:flutter/material.dart';

//------------------------------------------------------------------------------
// VARIABLES GLOBALES DEL JUEGO
//------------------------------------------------------------------------------

// Configuración del tablero
late int filas;
late int columnas;
late int cartasTotales;
late int parejasTotales;

// Las cartas y su estado
late List<String> imagenes; // Los iconos de cada carta
late List<bool> cartasGiradas; // true = carta boca arriba
late List<bool> cartasEmparejadas; // true = ya hizo match

// Control del turno actual
int? _primeraCarta; // índice de la primera carta volteada
bool _puedoGirarLaCarta = true; // false = esperando a que se oculten las cartas

// Puntuaciones
int puntosTotales = 0; // Puntos acumulados (se guardan en disco)
int puntosPartida = 0; // Puntos solo de esta partida
int parejasAcertadas = 0;
int parejasFalladas = 0;

// Para el efecto visual de flash
Set<int> cartasDestello = {};

final GlobalKey<WidTemporizadorState> timerKey = GlobalKey<WidTemporizadorState>();

//------------------------------------------------------------------------------
// FUNCIONES DE INICIALIZACIÓN
//------------------------------------------------------------------------------

void inicializarJuego(int pFilas, int pColumnas) async {
  filas = pFilas;
  columnas = pColumnas;
  cartasTotales = filas * columnas;
  parejasTotales = cartasTotales ~/ 2;

  // Conseguir los iconos aleatorios
  imagenes = SrvImagenes.obtenerImagenes(parejasTotales);

  // Resetear todos los estados
  cartasGiradas = List.filled(cartasTotales, false);
  cartasEmparejadas = List.filled(cartasTotales, false);

  _primeraCarta = null;
  _puedoGirarLaCarta = true;

  parejasAcertadas = 0;
  parejasFalladas = 0;
  puntosPartida = 0;

  cartasDestello = {};

  // Cargar puntos guardados del disco
  puntosTotales = await Diskette.leerValor("puntuacion", defaultValue: 0);
}

void resetearJuego() {
  inicializarJuego(filas, columnas);
}

//------------------------------------------------------------------------------
// FUNCIONES DE LÓGICA PURA
//------------------------------------------------------------------------------

// Comprobamos si 2 cartas son iguales:

bool esPareja(int carta1, int carta2) {
  return imagenes[carta1] == imagenes[carta2];
}

// Si todas las cartas están emparejadas, se acabó el juego:

bool juegoTerminado() {
  for (bool emparejada in cartasEmparejadas) {
    if (!emparejada) return false;
  }
  return true;
}

// Sumamos puntos:

void sumarPuntos() {
  puntosTotales += InfoJuego.niveles[InfoJuego.nivelSeleccionado]["puntosMas"] as int;
  puntosPartida += InfoJuego.niveles[InfoJuego.nivelSeleccionado]["puntosMas"] as int;
}

// Restamos puntos:

void restarPuntos() {
  puntosTotales -= InfoJuego.niveles[InfoJuego.nivelSeleccionado]["puntosMenos"] as int;
  puntosPartida -= InfoJuego.niveles[InfoJuego.nivelSeleccionado]["puntosMenos"] as int;
}

//------------------------------------------------------------------------------
// FUNCIÓN PRINCIPAL: MANEJAR EL TOQUE EN UNA CARTA
//------------------------------------------------------------------------------

Future<void> manejarToqueCarta(int index, Function pSetState) async {
  // 1. VERIFICACIONES BÁSICAS

  // Si no puedo girar, ignoro el toque
  if (!_puedoGirarLaCarta) return;

  // Si la carta ya está girada o emparejada, ignoro
  if (cartasGiradas[index] || cartasEmparejadas[index]) return;

  // 2. VOLTEAR LA CARTA
  pSetState(() {
    cartasGiradas[index] = true;
  });

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
      cartasEmparejadas[indicePrimera] = true;
      cartasEmparejadas[indiceSegunda] = true;
      _primeraCarta = null;
    });

    parejasAcertadas++;
    sumarPuntos();

    // Efecto visual de parpadeo
    pSetState(() {
      cartasDestello.add(indicePrimera);
      cartasDestello.add(indiceSegunda);
    });

    // Emitimos sonido y "destello" si hemos acertado la pareja:
    Sonidos.level();
    await Future.delayed(const Duration(milliseconds: 900));

    pSetState(() {
      cartasDestello.clear();
    });

    // Verificar si hemos terminado el juego
    if (juegoTerminado()) {
      Diskette.guardarValor("puntuacion", puntosTotales);
    }
  } else {
    //----------------------------
    // LAS 2 CARTAS SON DIFERENTES
    //----------------------------

    _puedoGirarLaCarta = false; // Bloqueamos más toques
    parejasFalladas++;
    restarPuntos();

    // Esperamos para que el jugador las vea las cartas desparejadas:

    await Future.delayed(const Duration(milliseconds: 900));

    Sonidos.goback();

    // Las volvemos a ocultar
    pSetState(() {
      cartasGiradas[indicePrimera] = false;
      cartasGiradas[indiceSegunda] = false;
      _primeraCarta = null;
      _puedoGirarLaCarta = true;
    });
  }
}

//------------------------------------------------------------------------------
// Función para controlar si el juego ha acabado o no.
//------------------------------------------------------------------------------

Future<void> controlJuegoAcabado(BuildContext pContexto, Function pSetState) async {
  if (juegoTerminado()) {
    timerKey.currentState?.stop();

    // Anotamos el resultado en Supabase:

    SrvSupabase.grabarPartida(
      pId: Diskette.leerValor("deviceId", defaultValue: "???"),
      pNivel: InfoJuego.nivelSeleccionado,
      pNombre: Diskette.leerValor("deviceName", defaultValue: "Cocinero Ryback"),
      pPais: "ES",
      pPuntos: puntosTotales,
      pTiempo: timerKey.currentState!.getTiempoFormateado,
      pActualizado: Fechas.hoyEnYYYYMMDD(),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    if (pContexto.mounted) {
      widJuegoAcabado(
        pContexto,
        puntosPartida,
        puntosTotales,
        timerKey.currentState!.getTiempoFormateado,
        pAlJugarOtraVez: () {
          pSetState(() {
            resetearJuego();
            timerKey.currentState?.reset();
            timerKey.currentState?.start();
          });
        },
      );
    }
  }
}
