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
  static bool sonCartasIguales(EstadoJuego pEstado, int pCarta1, int pCarta2) {
    return pEstado.listaDeImagenes[pCarta1] == pEstado.listaDeImagenes[pCarta2];
  }

  //----------------------------------------------------------------------------
  // FUNCIÓN: Verificar si el juego ha terminado
  //----------------------------------------------------------------------------
  static bool estaJuegoTerminado(EstadoJuego pEstado) {
    return pEstado.listaDeCartasEmparejadas.every((emparejada) => emparejada);
  }

  //----------------------------------------------------------------------------
  // FUNCIÓN: Calcular puntos según acierto o fallo
  //----------------------------------------------------------------------------
  static int calcularPuntos(int pPuntosActuales, bool pEsAcierto) {
    final nivel = InfoJuego.niveles[InfoJuego.nivelSeleccionado];

    if (pEsAcierto) {
      return pPuntosActuales + (nivel['puntosMas'] as int);
    } else {
      return pPuntosActuales - (nivel['puntosMenos'] as int);
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
        nuevoEstado: _copiarEstado(pEstado, pListaDeCartasGiradas: nuevasCartasGiradas, pPrimeraCarta: pIndex),
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
        nuevoEstado: _copiarEstado(
          pEstado,
          pListaDeCartasGiradas: nuevasCartasGiradas,
          pListaDeCartasEmparejadas: nuevasEmparejadas,
          pResetearPrimeraCarta: true,
          pParejasAcertadas: pEstado.parejasAcertadas + 1,
          pPuntosPartida: calcularPuntos(pEstado.puntosPartida, true),
          pCartasDestello: nuevoDestello,
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
        nuevoEstado: _copiarEstado(
          pEstado,
          pListaDeCartasGiradas: nuevasCartasGiradas,
          pResetearPrimeraCarta: true,
          pParejasFalladas: pEstado.parejasFalladas + 1,
          pPuntosPartida: calcularPuntos(pEstado.puntosPartida, false),
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
  static EstadoJuego ocultarCartasFalladas(EstadoJuego pEstado, int pIndex1, int pIndex2) {
    // Solo ocultamos si no han sido emparejadas mientras tanto
    if (pEstado.listaDeCartasEmparejadas[pIndex1] || pEstado.listaDeCartasEmparejadas[pIndex2]) {
      return pEstado;
    }

    List<bool> nuevasCartasGiradas = List.from(pEstado.listaDeCartasGiradas);
    nuevasCartasGiradas[pIndex1] = false;
    nuevasCartasGiradas[pIndex2] = false;

    return _copiarEstado(pEstado, pListaDeCartasGiradas: nuevasCartasGiradas);
  }

  //----------------------------------------------------------------------------
  // FUNCIÓN: Limpiar el efecto de destello
  //----------------------------------------------------------------------------
  static EstadoJuego limpiarDestello(EstadoJuego pEstado) {
    return _copiarEstado(pEstado, pCartasDestello: {});
  }

  //----------------------------------------------------------------------------
  // Helper para copiar estado con cambios
  //----------------------------------------------------------------------------
  static EstadoJuego _copiarEstado(
    EstadoJuego pEstado, {
    List<bool>? pListaDeCartasGiradas,
    List<bool>? pListaDeCartasEmparejadas,
    int? pPrimeraCarta,
    bool pResetearPrimeraCarta = false,
    int? pPuntosPartida,
    int? pParejasAcertadas,
    int? pParejasFalladas,
    Set<int>? pCartasDestello,
  }) {
    return EstadoJuego(
      filas: pEstado.filas,
      columnas: pEstado.columnas,
      cartasTotales: pEstado.cartasTotales,
      parejasTotales: pEstado.parejasTotales,
      listaDeImagenes: pEstado.listaDeImagenes,
      listaDeCartasGiradas: pListaDeCartasGiradas ?? List.from(pEstado.listaDeCartasGiradas),
      listaDeCartasEmparejadas: pListaDeCartasEmparejadas ?? List.from(pEstado.listaDeCartasEmparejadas),
      primeraCarta: pResetearPrimeraCarta ? null : (pPrimeraCarta ?? pEstado.primeraCarta),
      puedoGirarCarta: pEstado.puedoGirarCarta,
      puntosPartida: pPuntosPartida ?? pEstado.puntosPartida,
      parejasAcertadas: pParejasAcertadas ?? pEstado.parejasAcertadas,
      parejasFalladas: pParejasFalladas ?? pEstado.parejasFalladas,
      cartasDestello: pCartasDestello ?? Set.from(pEstado.cartasDestello),
    );
  }
}
