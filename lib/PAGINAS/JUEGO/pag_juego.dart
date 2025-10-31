//==============================================================================
// PÁGINA DE JUEGO
// Solo UI: muestra widgets, reproduce sonidos, coordina el flujo
// NO habla con la base de datos (eso lo hace srv_juego)
//==============================================================================

import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/srv_juego.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_juego_acabado.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_cronometro.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_contador.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_resumen.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_carta.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_cronometro.dart';

class PagJuego extends StatefulWidget {
  const PagJuego({super.key});

  @override
  State<PagJuego> createState() => _PagJuegoState();
}

class _PagJuegoState extends State<PagJuego> {
  bool _juegoListo = false;
  bool _cronometroIniciado = false;

  final GlobalKey<WidResumenState> _claveResumen = GlobalKey<WidResumenState>();

  //----------------------------------------------------------------------------
  // Cuando se crea la página
  //----------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    SrvLogger.grabarLog('pag_juego', 'initState()', 'Entramos en la página');
    _inicializar();
  }

  //----------------------------------------------------------------------------
  // Cuando se destruye la página
  //----------------------------------------------------------------------------
  @override
  void dispose() async {
    await SrvSonidos.detenerMusicaFondo();
    InfoJuego.musicaActiva = false;
    SrvLogger.grabarLog('pag_juego', 'dispose()', 'Salimos de la página');
    super.dispose();
  }

  //----------------------------------------------------------------------------
  // Preparar todo para empezar a jugar
  //----------------------------------------------------------------------------
  void _inicializar() async {
    //Forzamos una "microparada" de la ejecución para que el sistema tenga
    //tiempo de procesar todas las tareas síncronas de la inicialización
    //incluida la finalización de initState()
    await Future.microtask(() {});

    //Si durante la microparada anterior un usuario Speedy Gonsales ha pulsado
    //el botón de salir y ejecutado el dispose(), tenemos que irnos.
    if (!mounted) return;

    //Inicializamos todas las variables del estado de una partida.
    //Bajamos la lista de imagenes para la partida e inicializamos la lista de
    //cartas giradas y cartas emparejadas.
    SrvJuego.crearNuevoJuego(InfoJuego.filasSeleccionadas, InfoJuego.columnasSeleccionadas);

    //Marcamos el juego como inicializado. Colocamos la variable dentro de un
    //"setState" porque es un valor que utiliza la UI para actualizar elementos.
    setState(() {
      _juegoListo = true;
    });

    //Con la instrucción anterior, la UI habrá tenido que reconstruir elementos.
    //Con esta instrucción le decimos que llame a "refrescarDatos" cuando
    //termine de reconstruirse.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _claveResumen.currentState?.refrescarDatos();
    });

    SrvSonidos.iniciarMusicaFondo();
    InfoJuego.musicaActiva = true;
  }

  //----------------------------------------------------------------------------
  // Reiniciar el juego desde cero
  //----------------------------------------------------------------------------
  void _reiniciar() {
    SrvLogger.grabarLog('pag_juego', 'reiniciar()', 'Reiniciando');

    setState(() {
      SrvJuego.crearNuevoJuego(EstadoDelJuego.filas, EstadoDelJuego.columnas);
      _cronometroIniciado = false;
    });

    SrvCronometro.reset();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _claveResumen.currentState?.refrescarDatos();
    });
  }

  //----------------------------------------------------------------------------
  // FUNCIÓN PRINCIPAL: Cuando el usuario pulsa una carta
  //----------------------------------------------------------------------------
  Future<void> _cuandoPulsanUnaCarta(int pIndex) async {
    // Arrancar cronómetro en la primera carta
    if (!_cronometroIniciado) {
      _cronometroIniciado = true;
      SrvCronometro.reset();
      SrvCronometro.start();
      InfoJuego.juegoEnCurso = true;
      InfoJuego.juegoPausado = false;
    }

    // Procesar la carta (la lógica está en srv_juego)
    SrvJuego.procesarCartaPulsada(pIndex);

    // Refrescar pantalla
    setState(() {});

    // Reaccionar según lo que pasó
    switch (ResultadoClick.accion) {
      case TipoAccion.ignorar:
        break;

      case TipoAccion.primeraCartaGirada:
        SrvSonidos.flip();
        break;

      case TipoAccion.parejasIguales:
        SrvSonidos.flip();
        Future.delayed(const Duration(milliseconds: 300), () {
          SrvSonidos.level();
          Future.delayed(const Duration(milliseconds: 900), () {
            SrvJuego.ocultarCartasFalladas();
            SrvJuego.limpiarDestello();
            setState(() {});
            if (SrvJuego.estaJuegoTerminado()) {
              _finalizarJuego();
            }
          });
        });
        break;

      case TipoAccion.parejasDiferentes:
        SrvSonidos.flip();
        Future.delayed(const Duration(milliseconds: 900), () {
          SrvSonidos.goback();
          //SrvJuego.ocultarCartasFalladas(ResultadoClick.indicePrimera!, ResultadoClick.indiceSegunda!);
          SrvJuego.ocultarCartasFalladas();
          setState(() {});
        });
        break;

      default:
        break;
    }
  }

  //----------------------------------------------------------------------------
  // El juego terminó
  //----------------------------------------------------------------------------
  Future<void> _finalizarJuego() async {
    SrvLogger.grabarLog("pag_juego", "finalizarJuego()", "Terminado");

    // Parar cronómetro y música
    SrvCronometro.stop();
    _cronometroIniciado = false;
    InfoJuego.juegoEnCurso = false;
    InfoJuego.juegoPausado = false;
    await SrvSonidos.detenerMusicaFondo();
    InfoJuego.musicaActiva = false;

    // Guardar y obtener datos (el servicio habla con la BD, no nosotros)
    await SrvJuego.guardarPartida();
    await SrvJuego.obtenerDatosFinJuego();

    // Mostrar popup
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widJuegoAcabado(
          context,
          DatosFinJuego.nombreNivel,
          DatosFinJuego.puntosPartida,
          DatosFinJuego.posicionRanking,
          DatosFinJuego.puntosRecord,
          DatosFinJuego.partidasTotales,
          DatosFinJuego.tiempoPartida,
          DatosFinJuego.tiempoNivel,
          DatosFinJuego.tiempoRecord,
          pFuncionDeCallback: _reiniciar,
        );
      });
    }
  }

  //----------------------------------------------------------------------------
  // Construir la interfaz
  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (!_juegoListo) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: WidToolbar(
        showMenuButton: false,
        showBackButton: true,
        subtitle: SrvTraducciones.get('subtitulo_app'),
        pFuncionCallBack: () async {
          if (EstadoDelJuego.puntosPartida < 0) {
            await SrvJuego.guardarPartida();
          }
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          WidResumen(key: _claveResumen),
          const SizedBox(height: 5),

          // Contadores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WidContador(pTexto: SrvTraducciones.get('puntos'), pContador: EstadoDelJuego.puntosPartida, pModo: 1),
              WidContador(
                pTexto: SrvTraducciones.get('aciertos'),
                pContador: EstadoDelJuego.parejasAcertadas,
                pModo: 1,
              ),
              WidContador(pTexto: SrvTraducciones.get('errores'), pContador: EstadoDelJuego.parejasFalladas, pModo: 2),
              WidCronometro(),
            ],
          ),

          // Grid de cartas
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: EstadoDelJuego.columnas,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: EstadoDelJuego.cartasTotales,
                itemBuilder: (context, index) {
                  return WidCarta(
                    pEstaBocaArriba:
                        EstadoDelJuego.listaDeCartasGiradas[index] || EstadoDelJuego.listaDeCartasEmparejadas[index],
                    pImagenCarta: EstadoDelJuego.listaDeImagenes[index],
                    pDestello: EstadoDelJuego.cartasDestello.contains(index),
                    pCallBackFunction: () => _cuandoPulsanUnaCarta(index),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
