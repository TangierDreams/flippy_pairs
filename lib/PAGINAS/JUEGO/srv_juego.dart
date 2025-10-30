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
      //Creamos una lista de tamaño fijo (cartasTotales) y colocamos todos sus
      //valores a "false". Al inicio todas las cartas están boca abajo:
      listaDeCartasGiradas: List.filled(cartasTotales, false),
      //Creamos otra lista de tamaño fijo y al inicio del juego no hay ninguna
      //carta emparejada. Estan todas a false.
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
  static ResultadoCartaPulsada procesarCartaPulsada(EstadoJuego pEstado, int pIndex) {
    // 1. VERIFICACIONES BÁSICAS

    // Si no se puede girar la carta, se ignora:
    if (!pEstado.puedoGirarCarta) {
      return ResultadoCartaPulsada(nuevoEstado: pEstado, accion: TipoAccion.ignorar);
    }

    // Si la carta ya está girada o emparejada, se ignora
    if (pEstado.listaDeCartasGiradas[pIndex] || pEstado.listaDeCartasEmparejadas[pIndex]) {
      return ResultadoCartaPulsada(nuevoEstado: pEstado, accion: TipoAccion.ignorar);
    }

    // 2. GIRAR LA CARTA

    List<bool> nuevasCartasGiradas = List.from(pEstado.listaDeCartasGiradas);
    nuevasCartasGiradas[pIndex] = true;

    // 3. ¿ES LA PRIMERA O LA SEGUNDA CARTA?

    if (pEstado.primeraCarta == null) {
      // Es la primera carta del turno
      return ResultadoCartaPulsada(
        nuevoEstado: pEstado.copiarCon(listaDeCartasGiradas: nuevasCartasGiradas, primeraCarta: pIndex),
        accion: TipoAccion.primeraCartaGirada,
      );
    }

    // Es la segunda carta - vamos a compararlas
    final indicePrimera = pEstado.primeraCarta!;
    final indiceSegunda = pIndex;

    // 4. COMPROBAR SI HACEN PAREJA

    if (sonCartasIguales(pEstado, indicePrimera, indiceSegunda)) {
      //--------------------------------------------------------------------
      // ACIERTO: Las cartas son iguales
      //--------------------------------------------------------------------

      List<bool> nuevasEmparejadas = List.from(pEstado.listaDeCartasEmparejadas);
      nuevasEmparejadas[indicePrimera] = true;
      nuevasEmparejadas[indiceSegunda] = true;

      Set<int> nuevoDestello = {indicePrimera, indiceSegunda};

      return ResultadoCartaPulsada(
        nuevoEstado: pEstado.copiarCon(
          listaDeCartasGiradas: nuevasCartasGiradas,
          listaDeCartasEmparejadas: nuevasEmparejadas,
          primerCartaNula: true,
          parejasAcertadas: pEstado.parejasAcertadas + 1,
          puntosPartida: calcularPuntos(pEstado.puntosPartida, true),
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
        nuevoEstado: pEstado.copiarCon(
          listaDeCartasGiradas: nuevasCartasGiradas,
          primerCartaNula: true,
          parejasFalladas: pEstado.parejasFalladas + 1,
          puntosPartida: calcularPuntos(pEstado.puntosPartida, false),
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
