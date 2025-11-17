import 'dart:io';

import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_confirmacion.dart';
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
import 'package:google_fonts/google_fonts.dart';

class PagHome extends StatefulWidget {
  const PagHome({super.key});

  @override
  State<PagHome> createState() => _PagHomeState();
}

class _PagHomeState extends State<PagHome> {
  final List<bool> _isSelected = [false, false, false];

  @override
  void initState() {
    super.initState();
    SrvLogger.grabarLog('pag_home', 'initState()', 'Entramos en la pagina Home');
    int velocidadJuego = SrvDiskette.leerValor(DisketteKey.velocidadJuego, defaultValue: 1);
    _isSelected[velocidadJuego] = true;
  }

  @override
  void dispose() {
    SrvLogger.grabarLog('pag_home', 'dispose()', 'Salimos de la pagina Home');
    super.dispose();
  }

  void comprobarVersion(BuildContext pContexto) async {
    String cadena = await SrvSupabase.getParam('flippy_version', pDefaultValue: '0.0;O');
    List<String> partes = cadena.split(';');
    double versionNumero = double.parse(partes[0]);
    String versionTipo = partes[1];
    if (SrvDatosGenerales.versionLocal < versionNumero) {
      SrvConfirmacion.confirmacion(
        context: pContexto,
        pTitulo: 'Nueva Versión',
        pDescripcion:
            'Ha salido una nueva versión de Flippy Points. Por favor, actualice la app cuando pueda. Muchas gracias.',
      );
    }
  }

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

          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  SrvTraducciones.get('temas'),
                  textAlign: TextAlign.center,
                  style: SrvFuentes.chewy(
                    context,
                    30,
                    SrvColores.get(context, ColorKey.destacado),
                    pColorSombra: SrvColores.get(context, ColorKey.negro),
                  ),
                ),

                //const SizedBox(height: 10),
                SrvFuncionesGenericas.espacioVertical(context, 1),

                //------------------------------------------------------------------
                // Primera línea de imagenes
                //------------------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: BotonTema(
                        pListaImagenes: 'retratos',
                        pNumBoton: 0,
                        pCallBackFunction: () {
                          setState(() {
                            EstadoDelJuego.nomTema = 'retratos';
                            EstadoDelJuego.tema = 0;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 40),

                    Expanded(
                      child: BotonTema(
                        pListaImagenes: 'iconos',
                        pNumBoton: 1,
                        pCallBackFunction: () {
                          setState(() {
                            EstadoDelJuego.nomTema = 'iconos';
                            EstadoDelJuego.tema = 1;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 40),

                    Expanded(
                      child: BotonTema(
                        pListaImagenes: 'logos',
                        pNumBoton: 2,
                        pCallBackFunction: () {
                          setState(() {
                            EstadoDelJuego.nomTema = 'logos';
                            EstadoDelJuego.tema = 2;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                //const SizedBox(height: 10),
                SrvFuncionesGenericas.espacioVertical(context, 1),

                //------------------------------------------------------------------
                // Segunda línea de imagenes
                //------------------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: BotonTema(
                        pListaImagenes: 'coches',
                        pNumBoton: 3,
                        pCallBackFunction: () {
                          setState(() {
                            EstadoDelJuego.nomTema = 'coches';
                            EstadoDelJuego.tema = 3;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 40),

                    Expanded(
                      child: BotonTema(
                        pListaImagenes: 'herramientas',
                        pNumBoton: 4,
                        pCallBackFunction: () {
                          setState(() {
                            EstadoDelJuego.nomTema = 'herramientas';
                            EstadoDelJuego.tema = 4;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 40),

                    Expanded(
                      child: BotonTema(
                        pListaImagenes: 'animales',
                        pNumBoton: 5,
                        pCallBackFunction: () {
                          setState(() {
                            EstadoDelJuego.nomTema = 'animales';
                            EstadoDelJuego.tema = 5;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                //const SizedBox(height: 25),
                SrvFuncionesGenericas.espacioVertical(context, 2),

                //------------------------------------------------------------------
                // Botones de dificultad
                //------------------------------------------------------------------
                Text(
                  SrvTraducciones.get('dificultad'),
                  textAlign: TextAlign.center,
                  style: SrvFuentes.chewy(
                    context,
                    30,
                    SrvColores.get(context, ColorKey.destacado),
                    pColorSombra: SrvColores.get(context, ColorKey.negro),
                  ),
                ),

                //const SizedBox(height: 10),
                SrvFuncionesGenericas.espacioVertical(context, 1),

                //------------------------------------------------------------------
                // Primera fila de niveles de juego:
                //------------------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //-----------
                    // Nivel 3x2:
                    //-----------
                    Expanded(
                      child: BotonNivel(
                        pFilas: 3,
                        pColumnas: 2,
                        pNivel: 0,
                        pCallBackFunction: () {
                          setState(() {
                            EstadoDelJuego.nivel = 0;
                            EstadoDelJuego.filas = 3;
                            EstadoDelJuego.columnas = 2;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 40),

                    //-----------
                    // Nivel 4x3:
                    //-----------
                    Expanded(
                      child: BotonNivel(
                        pFilas: 4,
                        pColumnas: 3,
                        pNivel: 1,
                        pCallBackFunction: () {
                          setState(() {
                            EstadoDelJuego.nivel = 1;
                            EstadoDelJuego.filas = 4;
                            EstadoDelJuego.columnas = 3;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 40),

                    //-----------
                    // Nivel 5x4:
                    //-----------
                    Expanded(
                      child: BotonNivel(
                        pFilas: 5,
                        pColumnas: 4,
                        pNivel: 2,
                        pCallBackFunction: () {
                          setState(() {
                            EstadoDelJuego.nivel = 2;
                            EstadoDelJuego.filas = 5;
                            EstadoDelJuego.columnas = 4;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                //const SizedBox(height: 10),
                SrvFuncionesGenericas.espacioVertical(context, 1),

                //------------------------------------------------------------------
                // Segunda fila de niveles de juego:
                //------------------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //-----------
                    // Nivel 6x5:
                    //-----------
                    Expanded(
                      child: BotonNivel(
                        pFilas: 6,
                        pColumnas: 5,
                        pNivel: 3,
                        pCallBackFunction: () {
                          setState(() {
                            EstadoDelJuego.nivel = 3;
                            EstadoDelJuego.filas = 6;
                            EstadoDelJuego.columnas = 5;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 40),

                    //-----------
                    // Nivel 8x7:
                    //-----------
                    Expanded(
                      child: BotonNivel(
                        pFilas: 8,
                        pColumnas: 7,
                        pNivel: 4,
                        pCallBackFunction: () {
                          setState(() {
                            EstadoDelJuego.nivel = 4;
                            EstadoDelJuego.filas = 8;
                            EstadoDelJuego.columnas = 7;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 40),

                    //-----------
                    // Nivel 9x8:
                    //-----------
                    Expanded(
                      child: BotonNivel(
                        pFilas: 9,
                        pColumnas: 8,
                        pNivel: 5,
                        pCallBackFunction: () {
                          setState(() {
                            EstadoDelJuego.nivel = 5;
                            EstadoDelJuego.filas = 9;
                            EstadoDelJuego.columnas = 8;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                //const SizedBox(height: 25),
                SrvFuncionesGenericas.espacioVertical(context, 2),

                //--------------------------------------------------------------
                // Aquí seleccionamos la velocidad del juego.
                //--------------------------------------------------------------
                Text(
                  SrvTraducciones.get('velocidad_juego'),
                  textAlign: TextAlign.center,
                  style: SrvFuentes.chewy(
                    context,
                    30,
                    SrvColores.get(context, ColorKey.destacado),
                    pColorSombra: SrvColores.get(context, ColorKey.negro),
                  ),
                ),

                //const SizedBox(height: 10),
                SrvFuncionesGenericas.espacioVertical(context, 1),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final double buttonWidth = (constraints.maxWidth - 8) / 3;
                    return ToggleButtons(
                      // 2. The Logic: Handle the selection change
                      onPressed: (int index) {
                        SrvSonidos.boton();
                        setState(() {
                          //Reset all to false, then set the tapped index to true
                          for (int i = 0; i < _isSelected.length; i++) {
                            _isSelected[i] = (i == index);
                          }
                          // Update your GameSpeed variable and save to SrvDiskette
                          //_selectedSpeed = _velocidadJuego;
                          SrvDiskette.guardarValor(DisketteKey.velocidadJuego, index);
                        });
                      },

                      // 3. The State: Which button is currently selected
                      isSelected: _isSelected,

                      // 4. Custom Styling (Matching your previous colors):
                      borderColor: SrvColores.get(context, ColorKey.principal),
                      selectedBorderColor: SrvColores.get(context, ColorKey.principal),
                      fillColor: SrvColores.get(context, ColorKey.destacado),
                      color: SrvColores.get(context, ColorKey.principal),
                      selectedColor: SrvColores.get(context, ColorKey.negro),
                      borderRadius: BorderRadius.circular(10.0),

                      // 1. The Children: Your three styled Text widgets
                      children: <Widget>[
                        SizedBox(
                          width: buttonWidth,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            child: Text(
                              SrvTraducciones.get('lento'),
                              style: GoogleFonts.luckiestGuy(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: buttonWidth,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            child: Text(
                              SrvTraducciones.get('normal'),
                              style: GoogleFonts.luckiestGuy(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: buttonWidth,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            child: Text(
                              SrvTraducciones.get('rapido'),
                              style: GoogleFonts.luckiestGuy(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                //const SizedBox(height: 25),
                SrvFuncionesGenericas.espacioVertical(context, 2),

                //------------------------------------------------------------------
                // Botón para comenzar a jugar
                //------------------------------------------------------------------
                SizedBox(
                  height: 80,
                  child: WidBotonStandard(
                    pTexto: SrvTraducciones.get('comenzar_juego'),
                    pTipoDeLetra: 'Luckiest Guy',
                    pTamanyoLetra: 28,
                    pColorLetra: SrvColores.get(context, ColorKey.destacado),
                    pSombra: true,
                    pEsquinasRedondeadas: true,
                    pFuncionSonido: SrvSonidos.boton,
                    pNavegarA: '/game',
                  ),
                ),

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
// Botón Tema
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
          backgroundColor: estaSeleccionado
              ? SrvColores.get(context, ColorKey.destacado)
              : SrvColores.get(context, ColorKey.apoyo),
          foregroundColor: SrvColores.get(context, ColorKey.onPrincipal),
          elevation: estaSeleccionado ? 15 : 10,
        ),
        child: Image.file(primeraImagenTema, width: 60, height: 50, fit: BoxFit.contain),
      ),
    );
  }
}

//------------------------------------------------------------------------------
// Boton de nivel.
//------------------------------------------------------------------------------
class BotonNivel extends StatelessWidget {
  //final String pTitulo;
  final int pFilas;
  final int pColumnas;
  final int pNivel;
  final VoidCallback pCallBackFunction;

  const BotonNivel({
    super.key,
    //required this.pTitulo,
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
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: estaSeleccionado
              ? SrvColores.get(context, ColorKey.destacado)
              : SrvColores.get(context, ColorKey.principal),
          foregroundColor: SrvColores.get(context, ColorKey.onPrincipal),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: estaSeleccionado ? 15 : 10,
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
