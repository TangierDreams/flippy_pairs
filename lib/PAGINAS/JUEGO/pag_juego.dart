//==============================================================================
// PÁGINA DE JUEGO
// Responsable de: UI, setState, coordinación de efectos (sonidos, BD, etc.)
//==============================================================================

import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/srv_juego.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_juego_acabado.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_cronometro.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_supabase.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fechas.dart';
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
  late EstadoJuego _estadoJuego;
  bool _juegoInicializado = false;
  bool _cronometroIniciado = false;

  final GlobalKey<WidResumenState> _claveResumen = GlobalKey<WidResumenState>();

  @override
  void initState() {
    super.initState();
    SrvLogger.grabarLog('pag_juego', 'initState()', 'Entramos en la página de jugar');
    _inicializarPantalla();
  }

  @override
  void dispose() async {
    await SrvSonidos.detenerMusicaFondo();
    InfoJuego.musicaActiva = false;
    SrvLogger.grabarLog('pag_juego', 'dispose()', 'Salimos de la página de jugar');
    super.dispose();
  }

  //----------------------------------------------------------------------------
  // Inicializar el juego y preparar la pantalla
  //----------------------------------------------------------------------------
  void _inicializarPantalla() async {
    await Future.microtask(() {});
    if (!mounted) return;

    _estadoJuego = SrvJuego.crearNuevoJuego(InfoJuego.filasSeleccionadas, InfoJuego.columnasSeleccionadas);

    setState(() {
      _juegoInicializado = true;
    });

    // Refrescar datos del resumen después de construir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _claveResumen.currentState?.refrescarDatos();
    });

    // Iniciar música de fondo
    SrvSonidos.iniciarMusicaFondo();
    InfoJuego.musicaActiva = true;
  }

  //----------------------------------------------------------------------------
  // Resetear el juego desde cero
  //----------------------------------------------------------------------------
  void _resetearJuego() {
    SrvLogger.grabarLog('pag_juego', 'resetearJuego()', 'Reseteando el juego');

    setState(() {
      _estadoJuego = SrvJuego.crearNuevoJuego(_estadoJuego.filas, _estadoJuego.columnas);
      _cronometroIniciado = false;
    });

    SrvCronometro.reset();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _claveResumen.currentState?.refrescarDatos();
    });
  }

  //----------------------------------------------------------------------------
  // Manejar cuando el usuario pulsa una carta
  //----------------------------------------------------------------------------
  Future<void> _manejarCartaPulsada(int index) async {
    // Iniciar cronómetro en la primera carta
    if (!_cronometroIniciado) {
      _cronometroIniciado = true;
      SrvCronometro.reset();
      SrvCronometro.start();
      SrvLogger.grabarLog('pag_juego', 'cartaPulsada()', 'Cronómetro iniciado');
      InfoJuego.juegoEnCurso = true;
      InfoJuego.juegoPausado = false;
    }

    // Procesar la carta en la lógica pura
    final resultado = SrvJuego.procesarCartaPulsada(_estadoJuego, index);

    // Actualizar el estado visual
    setState(() {
      _estadoJuego = resultado.nuevoEstado;
    });

    // Reaccionar según el tipo de acción
    switch (resultado.accion) {
      case TipoAccion.ignorar:
        // No hacer nada
        break;

      case TipoAccion.primeraCartaGirada:
        // Solo sonido de girar
        SrvSonidos.flip();
        break;

      case TipoAccion.parejasIguales:
        // Sonido de girar + efecto de acierto
        SrvSonidos.flip();
        await Future.delayed(const Duration(milliseconds: 400));
        SrvSonidos.level();

        // Esperar y limpiar destello
        await Future.delayed(const Duration(milliseconds: 900));
        setState(() {
          _estadoJuego = SrvJuego.limpiarDestello(_estadoJuego);
        });

        // Verificar si terminó el juego
        if (SrvJuego.estaJuegoTerminado(_estadoJuego)) {
          await _finalizarJuego();
        }
        break;

      case TipoAccion.parejasDiferentes:
        // Sonido de girar + esperar + ocultar cartas
        SrvSonidos.flip();

        final i1 = resultado.indicePrimera!;
        final i2 = resultado.indiceSegunda!;

        await Future.delayed(const Duration(milliseconds: 900));
        SrvSonidos.goback();

        setState(() {
          _estadoJuego = SrvJuego.ocultarCartasFalladas(_estadoJuego, i1, i2);
        });
        break;
    }
  }

  //----------------------------------------------------------------------------
  // Finalizar el juego y mostrar resultados
  //----------------------------------------------------------------------------
  Future<void> _finalizarJuego() async {
    SrvLogger.grabarLog("pag_juego", "finalizarJuego()", "Juego terminado");

    SrvCronometro.stop();
    _cronometroIniciado = false;
    InfoJuego.juegoEnCurso = false;
    InfoJuego.juegoPausado = false;

    await SrvSonidos.detenerMusicaFondo();
    InfoJuego.musicaActiva = false;

    // Guardar resultado en Supabase
    await _guardarResultadoEnSupabase();

    // Obtener datos para el popup
    final datosDispositivo = await SrvSupabase.obtenerRegFlippy(
      pId: SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: ''),
    );

    final posicionFlippy = await SrvSupabase.obtenerRankingFlippy(
      pId: SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: ''),
      pLevel: InfoJuego.nivelSeleccionado,
    );

    final nivelJugado = InfoJuego.niveles[InfoJuego.nivelSeleccionado]['titulo'] as String;

    final registroNivel = datosDispositivo.firstWhere(
      (reg) => reg['nivel'] == InfoJuego.nivelSeleccionado,
      orElse: () => <String, dynamic>{},
    );

    // Mostrar popup
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widJuegoAcabado(
          context,
          nivelJugado,
          _estadoJuego.puntosPartida,
          posicionFlippy,
          registroNivel['puntos'],
          registroNivel['partidas'],
          SrvCronometro.obtenerTiempo(),
          SrvFechas.segundosAMinutosYSegundos(InfoJuego.niveles[InfoJuego.nivelSeleccionado]['tiempo'] as int),
          SrvFechas.segundosAMinutosYSegundos(registroNivel['tiempo_record']),
          pFuncionDeCallback: _resetearJuego,
        );
      });
    }
  }

  //----------------------------------------------------------------------------
  // Guardar el resultado de la partida en Supabase
  //----------------------------------------------------------------------------
  Future<void> _guardarResultadoEnSupabase() async {
    await SrvSupabase.grabarPartida(
      pId: SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: '?'),
      pNivel: InfoJuego.nivelSeleccionado,
      pNombre: SrvDiskette.leerValor(DisketteKey.deviceName, defaultValue: '?'),
      pPais: SrvDiskette.leerValor(DisketteKey.idPais, defaultValue: '?'),
      pCiudad: SrvDiskette.leerValor(DisketteKey.ciudad, defaultValue: '?'),
      pPuntos: _estadoJuego.puntosPartida,
      pTiempo: SrvCronometro.obtenerSegundos(),
      pGanada: _estadoJuego.puntosPartida > 0,
    );
  }

  //----------------------------------------------------------------------------
  // Construir la interfaz
  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (!_juegoInicializado) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: WidToolbar(
        showMenuButton: false,
        showBackButton: true,
        subtitle: SrvTraducciones.get('subtitulo_app'),
        pFuncionCallBack: () async {
          if (_estadoJuego.puntosPartida < 0) {
            await _guardarResultadoEnSupabase();
          }
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),

          // Barra de resumen
          WidResumen(key: _claveResumen),

          const SizedBox(height: 5),

          // Contadores y Timer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WidContador(pTexto: SrvTraducciones.get('puntos'), pContador: _estadoJuego.puntosPartida, pModo: 1),
              WidContador(pTexto: SrvTraducciones.get('aciertos'), pContador: _estadoJuego.parejasAcertadas, pModo: 1),
              WidContador(pTexto: SrvTraducciones.get('errores'), pContador: _estadoJuego.parejasFalladas, pModo: 2),
              WidCronometro(),
            ],
          ),

          // Grid de cartas
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _estadoJuego.columnas,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _estadoJuego.cartasTotales,
                itemBuilder: (context, index) {
                  return WidCarta(
                    pEstaBocaArriba:
                        _estadoJuego.listaDeCartasGiradas[index] || _estadoJuego.listaDeCartasEmparejadas[index],
                    pImagenCarta: _estadoJuego.listaDeImagenes[index],
                    pDestello: _estadoJuego.cartasDestello.contains(index),
                    pCallBackFunction: () => _manejarCartaPulsada(index),
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
