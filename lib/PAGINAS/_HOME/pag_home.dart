import 'dart:io';

import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/CONFIRMACION/srv_confirmacion.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_datos_generales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fuentes.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_funciones_genericas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_imagenes.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_idiomas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_supabase.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_boton_standard.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PagHome extends StatefulWidget {
  const PagHome({super.key});
  @override
  State<PagHome> createState() => _PagHomeState();
}

//==============================================================================
// CLASE PRINCIPAL.
//==============================================================================

class _PagHomeState extends State<PagHome> {
  final List<bool> _isSelected = [false, false, false];

  //----------------------------------------------------------------------------
  // Tareas al iniciar la página.
  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    SrvLogger.grabarLog('pag_home', 'initState()', 'Entramos en la pagina Home');
    int velocidadJuego = SrvDiskette.leerValor(DisketteKey.velocidadJuego, defaultValue: 1);
    _isSelected[velocidadJuego] = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _SupportFunctions().comprobarVersion(context);
    });
  }

  //----------------------------------------------------------------------------
  // Tareas antes de abandonar la página.
  //----------------------------------------------------------------------------

  @override
  void dispose() {
    SrvLogger.grabarLog('pag_home', 'dispose()', 'Salimos de la pagina Home');
    super.dispose();
  }

  //----------------------------------------------------------------------------
  // WIDGET PRINCIPAL.
  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    //Si cambia el SrvIdiomas.idiomaSeleccionado, se reconstruye la página:
    return ValueListenableBuilder<String>(
      valueListenable: SrvIdiomas.idiomaSeleccionado,
      builder: (context, idiomaActual, _) {
        return Scaffold(
          backgroundColor: SrvColores.get(context, ColorKey.fondo),
          //Toolbar:
          appBar: WidToolbar(
            showMenuButton: false,
            showBackButton: false,
            showConfigButton: true,
            subtitle: SrvTraducciones.get('subtitulo_app'),
          ),

          //----------------------------------
          // Contenedor principal de la página
          //----------------------------------
          body: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 24, 19, 97), // 1. Azul muy oscuro (Casi negro)
                  Color(0xFF4CA04C), // 2. Verde (o Menta oscura, punto medio)
                  Color(0xFFE9934B), // 3. Naranja (Parte inferior)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // Puedes añadir 'stops' si quieres controlar dónde cambia cada color:
                stops: [0.0, 0.7, 0.9],
              ),
              // Si añades un patrón de estrellas (tile) como imagen:
              image: DecorationImage(
                image: AssetImage('assets/imagenes/general/stars.png'),
                repeat: ImageRepeat.repeat,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                //-------------------------
                // Contenedor de los temas.
                //-------------------------
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: SrvColores.get(context, ColorKey.destacado),
                  ),

                  child: Row(
                    children: [
                      Column(
                        children: [
                          //----------------
                          // Título del tema
                          //----------------
                          Text(
                            SrvTraducciones.get('temas'),
                            textAlign: TextAlign.center,
                            style: SrvFuentes.chewy(
                              context,
                              30,
                              SrvColores.get(context, ColorKey.resaltado),
                              pColorSombra: SrvColores.get(context, ColorKey.negro),
                            ),
                          ),
                          SrvFuncionesGenericas.espacioVertical(context, 1),
                          //--------------------------
                          // Imagen principal del tema
                          //--------------------------
                          Image.asset('assets/imagenes/general/home.png', height: 100, fit: BoxFit.contain),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            //SrvFuncionesGenericas.espacioVertical(context, 1),

                            //-----------------------
                            // Primera fila de temas
                            //-----------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (int i = 0; i <= 2; i++)
                                  BotonTema(
                                    pListaImagenes: InfoTemas.tema[i]['listaImagenes'] as String,
                                    pNumBoton: i,
                                    pCallBackFunction: () {
                                      setState(() {
                                        EstadoDelJuego.nomTema = InfoTemas.tema[i]['nombre'] as String;
                                        EstadoDelJuego.tema = InfoTemas.tema[i]['id'] as int;
                                      });
                                    },
                                  ),
                              ],
                            ),
                            SrvFuncionesGenericas.espacioVertical(context, 1),

                            //----------------------
                            // Segunda fila de temas
                            //----------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (int i = 3; i <= 5; i++)
                                  BotonTema(
                                    pListaImagenes: InfoTemas.tema[i]['listaImagenes'] as String,
                                    pNumBoton: i,
                                    pCallBackFunction: () {
                                      setState(() {
                                        EstadoDelJuego.nomTema = InfoTemas.tema[i]['nombre'] as String;
                                        EstadoDelJuego.tema = InfoTemas.tema[i]['id'] as int;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //const SizedBox(height: 10),
                //SrvFuncionesGenericas.espacioVertical(context, 1),

                //const SizedBox(height: 25),
                SrvFuncionesGenericas.espacioVertical(context, 2),

                //----------------------
                // Contenedor de niveles
                //----------------------
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: SrvColores.get(context, ColorKey.principal),
                  ),

                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                SrvTraducciones.get('dificultad'),
                                textAlign: TextAlign.center,
                                style: SrvFuentes.chewy(
                                  context,
                                  30,
                                  SrvColores.get(context, ColorKey.resaltado),
                                  pColorSombra: SrvColores.get(context, ColorKey.negro),
                                ),
                              ),
                            ),

                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: Icon(Icons.emoji_events, color: const Color.fromARGB(255, 255, 102, 0), size: 40),
                            ),
                          ],
                        ),
                      ),
                      SrvFuncionesGenericas.espacioVertical(context, 2),

                      //---------------------------------
                      // Primera fila de niveles de juego
                      //---------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 0; i <= 2; i++)
                            BotonNivel(
                              pFilas: InfoNiveles.nivel[i]['filas'] as int,
                              pColumnas: InfoNiveles.nivel[i]['columnas'] as int,
                              pNivel: i,
                              pCallBackFunction: () {
                                setState(() {
                                  EstadoDelJuego.nivel = i;
                                  EstadoDelJuego.filas = InfoNiveles.nivel[i]['filas'] as int;
                                  EstadoDelJuego.columnas = InfoNiveles.nivel[i]['columnas'] as int;
                                });
                              },
                            ),
                        ],
                      ),
                      SrvFuncionesGenericas.espacioVertical(context, 1),

                      //---------------------------------
                      // Segunda fila de niveles de juego
                      //---------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 3; i <= 5; i++)
                            BotonNivel(
                              pFilas: InfoNiveles.nivel[i]['filas'] as int,
                              pColumnas: InfoNiveles.nivel[i]['columnas'] as int,
                              pNivel: i,
                              pCallBackFunction: () {
                                setState(() {
                                  EstadoDelJuego.nivel = i;
                                  EstadoDelJuego.filas = InfoNiveles.nivel[i]['filas'] as int;
                                  EstadoDelJuego.columnas = InfoNiveles.nivel[i]['columnas'] as int;
                                });
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                //const SizedBox(height: 25),
                SrvFuncionesGenericas.espacioVertical(context, 2),

                //-----------------------------------------
                // Contenedor de velocidad y botón de jugar
                //-----------------------------------------
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade900, // Verde oscuro
                        Colors.green.shade600, // Verde mediano
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),

                  child: Column(
                    children: [
                      //-----------------------
                      // Título de la velocidad
                      //-----------------------
                      Text(
                        SrvTraducciones.get('velocidad_juego'),
                        textAlign: TextAlign.center,
                        style: SrvFuentes.chewy(
                          context,
                          30,
                          SrvColores.get(context, ColorKey.resaltado),
                          pColorSombra: SrvColores.get(context, ColorKey.negro),
                        ),
                      ),
                      SrvFuncionesGenericas.espacioVertical(context, 2),

                      //--------------------------
                      // Selección de la velocidad
                      //--------------------------
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final double buttonWidth = (constraints.maxWidth - 8) / 3;
                          final List<String> velocidades = ['lento', 'normal', 'rapido'];

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (int i = 0; i < 3; i++)
                                GestureDetector(
                                  onTap: () {
                                    SrvSonidos.boton();
                                    setState(() {
                                      for (int j = 0; j < _isSelected.length; j++) {
                                        _isSelected[j] = (j == i);
                                      }
                                      SrvDiskette.guardarValor(DisketteKey.velocidadJuego, i);
                                    });
                                  },
                                  child: Container(
                                    width: buttonWidth,
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                      color: _isSelected[i]
                                          ? SrvColores.get(context, ColorKey.destacado)
                                          : SrvColores.get(context, ColorKey.principal), // Color para no seleccionados
                                      //border: Border.all(color: SrvColores.get(context, ColorKey.apoyo), width: 1),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Text(
                                      SrvTraducciones.get(velocidades[i]),
                                      style: GoogleFonts.luckiestGuy(
                                        fontSize: 14,
                                        color: _isSelected[i]
                                            ? SrvColores.get(context, ColorKey.blanco)
                                            : SrvColores.get(context, ColorKey.resaltado),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      SrvFuncionesGenericas.espacioVertical(context, 1),

                      //------------------------------------------------------------------
                      // Botón START PLAYING
                      //------------------------------------------------------------------
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: WidBotonStandard(
                          pTexto: SrvTraducciones.get('comenzar_juego'),
                          pTipoDeLetra: 'Luckiest Guy',
                          pTamanyoLetra: 26,
                          pColorDeFondo: SrvColores.get(context, ColorKey.resaltado),
                          pColorLetra: SrvColores.get(context, ColorKey.principal),
                          pSombra: true,
                          pEsquinasRedondeadas: true,
                          pFuncionSonido: SrvSonidos.boton,
                          pNavegarA: '/game',
                        ),
                      ),
                    ],
                  ),
                ),

                //const SizedBox(height: 25),
                //SrvFuncionesGenericas.espacioVertical(context, 2),

                //const SizedBox(height: 10),
                SrvFuncionesGenericas.espacioVertical(context, 1),

                //------------------------------------------------------------------
                // Botón para ir al Ranking de puntos
                //------------------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: WidBotonStandard(
                        pTexto: '🌎 WFC',
                        pTipoDeLetra: 'Chewy',
                        pTamanyoLetra: 18,
                        pColorLetra: SrvColores.get(context, ColorKey.resaltado), //Colores.tercero,
                        //pIcono: Icons.settings,
                        //pColorIcono: Colores.tercero,
                        pSombra: true,
                        pEsquinasRedondeadas: true,
                        pNavegarA: '/ranking',
                      ),
                    ),

                    const SizedBox(width: 10),

                    //------------------------------------------------------------------
                    // Botón para ir al Ranking de Tiempo
                    //------------------------------------------------------------------
                    Expanded(
                      child: WidBotonStandard(
                        pTexto: '🕒 TFC',
                        pTipoDeLetra: 'Chewy',
                        pTamanyoLetra: 18,
                        pColorLetra: SrvColores.get(context, ColorKey.resaltado),
                        //pIcono: Icons.settings,
                        //pColorIcono: Colores.tercero,
                        pSombra: true,
                        pEsquinasRedondeadas: true,
                        pNavegarA: '/ranking_time',
                      ),
                    ),

                    const SizedBox(width: 10),

                    //------------------------------------------------------------------
                    // Botón para ir al Ranking de Paises
                    //------------------------------------------------------------------
                    Expanded(
                      child: WidBotonStandard(
                        pTexto: '🏛️ CFC',
                        pTipoDeLetra: 'Chewy',
                        pTamanyoLetra: 18,
                        pColorLetra: SrvColores.get(context, ColorKey.resaltado),
                        //pIcono: Icons.settings,
                        //pColorIcono: Colores.tercero,
                        pSombra: true,
                        pEsquinasRedondeadas: true,
                        pNavegarA: '/ranking_countries',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

//------------------------------------------------------------------------------
// Widget para montar los botones de los temas.
//------------------------------------------------------------------------------
class BotonTema extends StatelessWidget {
  final String pListaImagenes;
  final int pNumBoton;
  final VoidCallback pCallBackFunction;

  const BotonTema({super.key, required this.pListaImagenes, required this.pNumBoton, required this.pCallBackFunction});

  @override
  Widget build(BuildContext context) {
    bool estaSeleccionado = pNumBoton == EstadoDelJuego.tema;
    File primeraImagenTema = SrvImagenes.obtenerUnaImagen(pListaImagenes, "01.png");

    return AnimatedScale(
      scale: estaSeleccionado ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      child: ElevatedButton(
        onPressed: () {
          SrvSonidos.boton();
          pCallBackFunction();
        },
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(10),
          backgroundColor: estaSeleccionado
              ? SrvColores.get(context, ColorKey.resaltado)
              : SrvColores.get(context, ColorKey.principal),
          foregroundColor: SrvColores.get(context, ColorKey.onPrincipal),
          elevation: estaSeleccionado ? 15 : 10,
          shadowColor: Colors.black,
        ),
        child: Image.file(primeraImagenTema, height: 40, fit: BoxFit.contain),
      ),
    );
  }
}

//------------------------------------------------------------------------------
// Widget para montar los botones de los niveles.
//------------------------------------------------------------------------------
class BotonNivel extends StatelessWidget {
  //final String pTitulo;
  final int pFilas;
  final int pColumnas;
  final int pNivel;
  final VoidCallback pCallBackFunction;

  const BotonNivel({
    super.key,
    required this.pFilas,
    required this.pColumnas,
    required this.pNivel,
    required this.pCallBackFunction,
  });

  @override
  Widget build(BuildContext context) {
    String titulo = '${pFilas}x$pColumnas';
    bool estaSeleccionado = pNivel == EstadoDelJuego.nivel;

    return AnimatedScale(
      scale: estaSeleccionado ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      child: ElevatedButton(
        onPressed: () async {
          SrvSonidos.boton();
          pCallBackFunction();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          backgroundColor: estaSeleccionado
              ? SrvColores.get(context, ColorKey.destacado)
              : SrvColores.get(context, ColorKey.apoyo),
          foregroundColor: SrvColores.get(context, ColorKey.onPrincipal),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: estaSeleccionado ? 15 : 10,
          shadowColor: Colors.black,
        ),
        child: Text(
          titulo,
          style: estaSeleccionado
              ? SrvFuentes.chewy(context, 30, SrvColores.get(context, ColorKey.onDestacado))
              : SrvFuentes.chewy(
                  context,
                  30,
                  SrvColores.get(context, ColorKey.resaltado),
                  pColorSombra: SrvColores.get(context, ColorKey.negro),
                ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

//==============================================================================
// FUNCIONES DE SOPORTE
//==============================================================================

class _SupportFunctions {
  //----------------------------------------------------------------------------
  // Comprobamos si ha salido una nueva versión.
  //----------------------------------------------------------------------------
  void comprobarVersion(BuildContext context) async {
    String cadena = await SrvSupabase.getParam('flippy_version', pDefaultValue: '0.0;O');
    if (!context.mounted) return;
    List<String> partes = cadena.split(';');
    double versionNumero = double.parse(partes[0]);
    String versionTipo = partes[1];
    if (SrvDatosGenerales.versionLocal < versionNumero) {
      if (versionTipo == 'M') {
        SrvConfirmacion.confirmacion(
          context: context,
          pModal: true,
          pTitulo: 'Nueva Versión',
          pTituloFont: 'Luckiest Guy',
          pDescripcion: SrvTraducciones.get('version_obligatoria'),
          pDescripcionFont: 'Chewy',
          pDosBotones: false,
          pBotonOkTexto: SrvTraducciones.get('descargar'),
          pBotonOkFont: 'Chewy',
          pBotonOkColor: SrvColores.get(context, ColorKey.exito),
          pOnConfirmar: () {
            abrirPlayStore(context);
            SystemNavigator.pop();
          },
        );
      } else {
        SrvConfirmacion.confirmacion(
          context: context,
          pTitulo: 'Nueva Versión',
          pTituloFont: 'Luckiest Guy',
          pDescripcion: SrvTraducciones.get('version_opcional'),
          pDescripcionFont: 'Chewy',
          pBotonOkTexto: SrvTraducciones.get('descargar'),
          pBotonOkFont: 'Chewy',
          pBotonOkColor: SrvColores.get(context, ColorKey.exito),
          pBotonKoTexto: SrvTraducciones.get('despues'),
          pBotonKoFont: 'Chewy',
          pBotonKoColor: SrvColores.get(context, ColorKey.texto),
          pOnConfirmar: () {
            abrirPlayStore(context);
          },
        );
      }
    }
  }

  void abrirPlayStore(BuildContext context) async {
    final url = Uri.parse(SrvDatosGenerales.urlGooglePlay);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // por si falla
      if (!context.mounted) return;
      Fluttertoast.showToast(
        msg: SrvTraducciones.get('puntuaciones_eliminadas'),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: SrvColores.get(context, ColorKey.principal),
        textColor: SrvColores.get(context, ColorKey.onPrincipal),
        fontSize: 16.0,
      );
    }
  }
}
