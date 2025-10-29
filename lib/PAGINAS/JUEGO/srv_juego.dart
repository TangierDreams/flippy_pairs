//==============================================================================
// SERVICIO DE LÓGICA DEL JUEGO
// Solo contiene lógica pura, sin efectos secundarios (UI, sonidos, BD)
//==============================================================================

import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_imagenes.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';

class SrvJuego {
  //----------------------------------------------------------------------------
  // FUNCIÓN: Crear un nuevo juego desde cero
  //----------------------------------------------------------------------------
  static EstadoJuego crearNuevoJuego(int pFilas, int pColumnas) {
    SrvLogger.grabarLog("srv_juego", "crearNuevoJuego()", "Creando nuevo juego");

    final cartasTotales = pFilas * pColumnas;
    final parejasTotales = cartasTotales ~/ 2;

    return EstadoJuego(
      filas: pFilas,
      columnas: pColumnas,
      cartasTotales: cartasTotales,
      parejasTotales: parejasTotales,
      listaDeImagenes: SrvImagenes.obtenerImagenesParaJugar(parejasTotales),
      listaDeCartasGiradas: List.filled(cartasTotales, false),
      listaDeCartasEmparejadas: List.filled(cartasTotales, false),
      primeraCarta: null,
      puedoGirarCarta: true,
      puntosPartida: 0,
      parejasAcertadas: 0,
      parejasFalladas: 0,
      cartasDestello: {},
    );
  }

  //----------------------------------------------------------------------------
  // FUNCIÓN: Verificar si dos cartas son iguales
  //----------------------------------------------------------------------------
  static bool sonCartasIguales(EstadoJuego estado, int carta1, int carta2) {
    return estado.listaDeImagenes[carta1] == estado.listaDeImagenes[carta2];
  }

  //----------------------------------------------------------------------------
  // FUNCIÓN: Verificar si el juego ha terminado
  //----------------------------------------------------------------------------
  static bool estaJuegoTerminado(EstadoJuego estado) {
    return estado.listaDeCartasEmparejadas.every((emparejada) => emparejada);
  }

  //----------------------------------------------------------------------------
  // FUNCIÓN: Calcular puntos según acierto o fallo
  //----------------------------------------------------------------------------
  static int calcularPuntos(int puntosActuales, bool esAcierto) {
    final nivel = InfoJuego.niveles[InfoJuego.nivelSeleccionado];

    if (esAcierto) {
      return puntosActuales + (nivel['puntosMas'] as int);
    } else {
      return puntosActuales - (nivel['puntosMenos'] as int);
    }
  }

  //----------------------------------------------------------------------------
  // FUNCIÓN PRINCIPAL: Procesar cuando el usuario pulsa una carta
  // Retorna el nuevo estado y la acción que ocurrió (para que la UI reaccione)
  //----------------------------------------------------------------------------
  static ResultadoCartaPulsada procesarCartaPulsada(EstadoJuego estado, int index) {
    // 1. VERIFICACIONES BÁSICAS

    // Si no puedo girar, ignoro
    if (!estado.puedoGirarCarta) {
      return ResultadoCartaPulsada(nuevoEstado: estado, accion: TipoAccion.ignorar);
    }

    // Si la carta ya está girada o emparejada, ignoro
    if (estado.listaDeCartasGiradas[index] || estado.listaDeCartasEmparejadas[index]) {
      return ResultadoCartaPulsada(nuevoEstado: estado, accion: TipoAccion.ignorar);
    }

    // 2. VOLTEAR LA CARTA

    List<bool> nuevasCartasGiradas = List.from(estado.listaDeCartasGiradas);
    nuevasCartasGiradas[index] = true;

    // 3. ¿ES LA PRIMERA O LA SEGUNDA CARTA?

    if (estado.primeraCarta == null) {
      // Es la primera carta del turno
      return ResultadoCartaPulsada(
        nuevoEstado: estado.copiarCon(listaDeCartasGiradas: nuevasCartasGiradas, primeraCarta: index),
        accion: TipoAccion.primeraCartaGirada,
      );
    }

    // Es la segunda carta - vamos a compararlas
    final indicePrimera = estado.primeraCarta!;
    final indiceSegunda = index;

    // 4. COMPROBAR SI HACEN PAREJA

    if (sonCartasIguales(estado, indicePrimera, indiceSegunda)) {
      //--------------------------------------------------------------------
      // ACIERTO: Las cartas son iguales
      //--------------------------------------------------------------------

      List<bool> nuevasEmparejadas = List.from(estado.listaDeCartasEmparejadas);
      nuevasEmparejadas[indicePrimera] = true;
      nuevasEmparejadas[indiceSegunda] = true;

      Set<int> nuevoDestello = {indicePrimera, indiceSegunda};

      return ResultadoCartaPulsada(
        nuevoEstado: estado.copiarCon(
          listaDeCartasGiradas: nuevasCartasGiradas,
          listaDeCartasEmparejadas: nuevasEmparejadas,
          primerCartaNula: true,
          parejasAcertadas: estado.parejasAcertadas + 1,
          puntosPartida: calcularPuntos(estado.puntosPartida, true),
          cartasDestello: nuevoDestello,
        ),
        accion: TipoAccion.parejasIguales,
        indicePrimera: indicePrimera,
        indiceSegunda: indiceSegunda,
      );
    } else {
      //--------------------------------------------------------------------
      // FALLO: Las cartas son diferentes
      //--------------------------------------------------------------------

      return ResultadoCartaPulsada(
        nuevoEstado: estado.copiarCon(
          listaDeCartasGiradas: nuevasCartasGiradas,
          primerCartaNula: true,
          parejasFalladas: estado.parejasFalladas + 1,
          puntosPartida: calcularPuntos(estado.puntosPartida, false),
        ),
        accion: TipoAccion.parejasDiferentes,
        indicePrimera: indicePrimera,
        indiceSegunda: indiceSegunda,
      );
    }
  }

  //----------------------------------------------------------------------------
  // FUNCIÓN: Ocultar cartas después de un fallo
  // Se llama después de un delay para que el usuario vea las cartas
  //----------------------------------------------------------------------------
  static EstadoJuego ocultarCartasFalladas(EstadoJuego estado, int index1, int index2) {
    // Solo ocultamos si no han sido emparejadas mientras tanto
    if (estado.listaDeCartasEmparejadas[index1] || estado.listaDeCartasEmparejadas[index2]) {
      return estado;
    }

    List<bool> nuevasCartasGiradas = List.from(estado.listaDeCartasGiradas);
    nuevasCartasGiradas[index1] = false;
    nuevasCartasGiradas[index2] = false;

    return estado.copiarCon(listaDeCartasGiradas: nuevasCartasGiradas);
  }

  //----------------------------------------------------------------------------
  // FUNCIÓN: Limpiar el efecto de destello
  //----------------------------------------------------------------------------
  static EstadoJuego limpiarDestello(EstadoJuego estado) {
    return estado.copiarCon(cartasDestello: {});
  }
}
