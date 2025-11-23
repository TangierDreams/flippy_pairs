//==============================================================================
// PÁGINA DE JUEGO
// Solo UI: muestra widgets, reproduce sonidos, coordina el flujo
// NO habla con la base de datos (eso lo hace srv_juego)
//==============================================================================

import 'dart:math';
import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/srv_juego.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_juego_acabado.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/srv_cronometro.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_datos_generales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_contador.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_resumen.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_carta.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_cronometro.dart';

class PagJuego extends StatefulWidget {
  const PagJuego({super.key});
  @override
  State<PagJuego> createState() => _PagJuegoState();
}

//==============================================================================
// CLASE PRINCIPAL.
//==============================================================================

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
    EstadoDelJuego.musicaActiva = false;
    EstadoDelJuego.juegoEnCurso = false;
    EstadoDelJuego.juegoPausado = false;
    SrvCronometro.reset();
    SrvLogger.grabarLog('pag_juego', 'dispose()', 'Salimos de la página');
    super.dispose();
  }

  //----------------------------------------------------------------------------
  // WIDGET PRINCIPAL.
  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    const double espacioBanner = 60;
    if (!_juegoListo) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: SrvColores.get(context, ColorKey.fondo),
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

      //----------------------------------
      // Contenedor principal de la página
      //----------------------------------
      body: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              SrvColores.get(context, ColorKey.degradadoPantalla1),
              SrvColores.get(context, ColorKey.degradadoPantalla2),
              SrvColores.get(context, ColorKey.degradadoPantalla3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Puedes añadir 'stops' si quieres controlar dónde cambia cada color:
            stops: [0.0, 0.7, 0.9],
          ),
          // Si añades un patrón de estrellas (tile) como imagen:
          image: DecorationImage(image: AssetImage(SrvDatosGenerales.fondoPantalla), repeat: ImageRepeat.repeat),
        ),
        child: Column(
          children: [
            //-----------------------------
            // Contenedor de los contadores
            //-----------------------------
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: SrvColores.get(context, ColorKey.principal),
              ),
              child: Column(
                children: [
                  //------------------------
                  // Resumen de puntos y WFC
                  //------------------------
                  WidResumen(key: _claveResumen),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //----------------
                      // Total de puntos
                      //----------------
                      WidContador(
                        pTexto: SrvTraducciones.get('puntos'),
                        pContador: EstadoDelJuego.puntosPartida,
                        pModo: 1,
                      ),
                      SizedBox(width: 10),
                      //---------------
                      // Total aciertos
                      //---------------
                      WidContador(
                        pTexto: SrvTraducciones.get('aciertos'),
                        pContador: EstadoDelJuego.parejasAcertadas,
                        pModo: 1,
                      ),
                      SizedBox(width: 10),
                      //--------------
                      // Total errores
                      //--------------
                      WidContador(
                        pTexto: SrvTraducciones.get('errores'),
                        pContador: EstadoDelJuego.parejasFalladas,
                        pModo: 2,
                      ),
                      SizedBox(width: 10),
                      //------
                      // Timer
                      //------
                      WidCronometro(),
                    ],
                  ),
                ],
              ),
            ),

            // Grid de cartas
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // IMPORTANTE: Restamos el espacio del banner del alto disponible

                  // Espacio disponible (restamos padding y spacing)
                  final double anchoDisponible = constraints.maxWidth - 24; // padding 12 + 12
                  final double altoDisponible = constraints.maxHeight - 24 - espacioBanner;

                  // Espacio entre cartas
                  final double crossSpacing = 8;
                  final double mainSpacing = 8;

                  // Calculamos el ancho de cada carta
                  final double anchoCartaPorEspacio =
                      (anchoDisponible - (crossSpacing * (EstadoDelJuego.columnas - 1))) / EstadoDelJuego.columnas;

                  // Calculamos el alto de cada carta si usáramos todo el espacio vertical
                  final double altoCartaPorEspacio =
                      (altoDisponible - (mainSpacing * (EstadoDelJuego.filas - 1))) / EstadoDelJuego.filas;

                  // Para mantener proporción cuadrada (o cercana), elegimos el menor de los dos
                  final double sizeCarta = min(anchoCartaPorEspacio, altoCartaPorEspacio);

                  // Calculamos el childAspectRatio basándonos en el tamaño real que tendrá cada carta
                  // Ratio = ancho / alto de cada celda del grid
                  final double childAspectRatio = anchoCartaPorEspacio / sizeCarta;

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: EstadoDelJuego.columnas,
                        crossAxisSpacing: crossSpacing,
                        mainAxisSpacing: mainSpacing,
                        childAspectRatio: childAspectRatio,
                        children: List.generate(EstadoDelJuego.cartasTotales, (index) {
                          return WidCarta(
                            pIndex: index,
                            pEstaBocaArriba:
                                EstadoDelJuego.listaDeCartasGiradas[index] ||
                                EstadoDelJuego.listaDeCartasEmparejadas[index],
                            pImagenCarta: EstadoDelJuego.listaDeImagenes[index],
                            pDestello: EstadoDelJuego.cartasDestello.contains(index),
                            pCallBackFunction: () => _cuandoPulsanUnaCarta(index),
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: espacioBanner),
          ],
        ),
      ),
    );
  }

  //============================================================================
  // Funciones de apoyo.
  //============================================================================

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
    SrvJuego.crearNuevoJuego(EstadoDelJuego.filas, EstadoDelJuego.columnas);

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
    EstadoDelJuego.musicaActiva = true;
  }

  //----------------------------------------------------------------------------
  // Reiniciar el juego desde cero
  //----------------------------------------------------------------------------
  void _reiniciar() {
    SrvLogger.grabarLog('pag_juego', 'reiniciar()', 'Reiniciando el juego');

    setState(() {
      SrvJuego.crearNuevoJuego(EstadoDelJuego.filas, EstadoDelJuego.columnas);
      _cronometroIniciado = false;
    });

    SrvCronometro.reset();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _claveResumen.currentState?.refrescarDatos();
      SrvSonidos.iniciarMusicaFondo();
      EstadoDelJuego.musicaActiva = true;
    });
  }

  //----------------------------------------------------------------------------
  // Tareas a realizar cuando se pulsa una carta.
  //----------------------------------------------------------------------------
  Future<void> _cuandoPulsanUnaCarta(int pIndex) async {
    SrvLogger.grabarLog("pag_juego", "_cuandoPulsanUnaCarta()", "Carta pulsada: $pIndex");
    // Arrancar cronómetro en la primera carta
    if (!_cronometroIniciado) {
      _cronometroIniciado = true;
      SrvCronometro.reset();
      SrvCronometro.start();
      EstadoDelJuego.juegoEnCurso = true;
      EstadoDelJuego.juegoPausado = false;
    }

    // Procesar la carta (la lógica está en srv_juego)
    SrvJuego.procesarCartaPulsada(pIndex);
    int velocidadJuego = SrvDiskette.leerValor(DisketteKey.velocidadJuego, defaultValue: 1);

    // Refrescar pantalla
    setState(() {});

    // Reaccionar según lo que pasó
    switch (ResultadoClick.accion) {
      case TipoAccion.ignorar:
        SrvLogger.grabarLog("pag_juego", "_cuandoPulsanUnaCarta()", "Carta ignorada: $pIndex");
        break;

      case TipoAccion.primeraCartaGirada:
        SrvLogger.grabarLog("pag_juego", "_cuandoPulsanUnaCarta()", "Primera carta: $pIndex");
        SrvSonidos.flip();
        break;

      case TipoAccion.parejasIguales:
        SrvLogger.grabarLog("pag_juego", "_cuandoPulsanUnaCarta()", "Cartas iguales: $pIndex");
        SrvSonidos.flip();

        // 🛑 1. ACTIVAR BLOQUEO
        EstadoDelJuego.procesandoTareas = true;
        SrvSonidos.level();

        // 3. Esperar un tiempo para mostrar el efecto lupa:
        await Future.delayed(Duration(milliseconds: GameSpeed.destello[velocidadJuego]));

        // 4. Limpiar destello y actualizar UI
        SrvJuego.limpiarDestello();
        setState(() {});

        // 5. Verificar fin de juego
        if (SrvJuego.estaJuegoTerminado()) {
          await _finalizarJuego();
        }

        // 🛑 6. DESBLOQUEAR
        EstadoDelJuego.procesandoTareas = false;
        break;

      case TipoAccion.parejasDiferentes:
        SrvLogger.grabarLog("pag_juego", "_cuandoPulsanUnaCarta()", "Cartas diferentes: $pIndex");
        SrvSonidos.flip();

        // 🛑 1. ACTIVAR BLOQUEO
        EstadoDelJuego.procesandoTareas = true;

        // 2. Esperar el tiempo de memorización
        await Future.delayed(Duration(milliseconds: GameSpeed.memo[velocidadJuego]));

        // 3. Revertir y actualizar UI (Inicia el giro inverso)
        SrvSonidos.goback();
        SrvJuego.ocultarCartasFalladas(ResultadoClick.primeraCarta!, ResultadoClick.segundaCarta!);
        setState(() {});

        // 4. Esperar a que el giro inverso termine (más rápido: 300ms)
        // Nota: Sugieres hacerlo más rápido. Usaremos 300ms en lugar de 550ms.
        //await Future.delayed(const Duration(milliseconds: 300));

        // 🛑 5. DESBLOQUEAR
        EstadoDelJuego.procesandoTareas = false;
        break;

      default:
        SrvLogger.grabarLog("pag_juego", "_cuandoPulsanUnaCarta()", "default?: $pIndex");
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
    EstadoDelJuego.juegoEnCurso = false;
    EstadoDelJuego.juegoPausado = false;
    await SrvSonidos.detenerMusicaFondo();
    EstadoDelJuego.musicaActiva = false;

    // Guardar y obtener datos (el servicio habla con la BD, no nosotros)
    await SrvJuego.guardarPartida();
    await SrvJuego.obtenerDatosFinJuego();

    // Para obtener una palabra aleatoria cuando mostramos el mensaje:
    Random random = Random();
    int msgAleatorio = random.nextInt(5) + 1;

    // Mostrar popup
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widJuegoAcabado(
          context,
          msgAleatorio,
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
}
