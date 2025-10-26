import 'dart:io';

import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_imagenes.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_idiomas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_boton_standard.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';

class PagHome extends StatefulWidget {
  const PagHome({super.key});

  @override
  State<PagHome> createState() => _PagHomeState();
}

class _PagHomeState extends State<PagHome> {
  @override
  void initState() {
    super.initState();
    SrvLogger.grabarLog('pag_home', 'initState()', 'Entramos en la pagina Home');
  }

  @override
  void dispose() {
    SrvLogger.grabarLog('pag_home', 'dispose()', 'Salimos de la pagina Home');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Si cambia el SrvIdiomas.idiomaSeleccionado, se reconstruye la página:
    return ValueListenableBuilder<String>(
      valueListenable: SrvIdiomas.idiomaSeleccionado,
      builder: (context, idiomaActual, _) {
        return Scaffold(
          //Toolbar:
          appBar: WidToolbar(
            showMenuButton: false,
            showBackButton: false,
            subtitle: SrvTraducciones.get('subtitulo_app'),
          ),

          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(SrvTraducciones.get('temas'), textAlign: TextAlign.center, style: Textos.textStyleOrange30),

                const SizedBox(height: 15),

                //------------------------------------------------------------------
                // Primera línea de imagenes
                //------------------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BotonTema(
                      pListaImagenes: 'iconos',
                      pNumBoton: 0,
                      pCallBackFunction: () {
                        setState(() {
                          InfoJuego.listaSeleccionada = 'iconos';
                          InfoJuego.temaSeleccionado = 0;
                        });
                      },
                    ),

                    BotonTema(
                      pListaImagenes: 'animales',
                      pNumBoton: 1,
                      pCallBackFunction: () {
                        setState(() {
                          InfoJuego.listaSeleccionada = 'animales';
                          InfoJuego.temaSeleccionado = 1;
                        });
                      },
                    ),

                    BotonTema(
                      pListaImagenes: 'retratos',
                      pNumBoton: 2,
                      pCallBackFunction: () {
                        setState(() {
                          InfoJuego.listaSeleccionada = 'retratos';
                          InfoJuego.temaSeleccionado = 2;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                //------------------------------------------------------------------
                // Segunda línea de imagenes
                //------------------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BotonTema(
                      pListaImagenes: 'herramientas',
                      pNumBoton: 3,
                      pCallBackFunction: () {
                        setState(() {
                          InfoJuego.listaSeleccionada = 'herramientas';
                          InfoJuego.temaSeleccionado = 3;
                        });
                      },
                    ),

                    BotonTema(
                      pListaImagenes: 'coches',
                      pNumBoton: 4,
                      pCallBackFunction: () {
                        setState(() {
                          InfoJuego.listaSeleccionada = 'coches';
                          InfoJuego.temaSeleccionado = 4;
                        });
                      },
                    ),

                    BotonTema(
                      pListaImagenes: 'logos',
                      pNumBoton: 5,
                      pCallBackFunction: () {
                        setState(() {
                          InfoJuego.listaSeleccionada = 'logos';
                          InfoJuego.temaSeleccionado = 5;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Text(SrvTraducciones.get('dificultad'), textAlign: TextAlign.center, style: Textos.textStyleOrange30),

                const SizedBox(height: 15),

                //------------------------------------------------------------------
                // Primera fila de niveles de juego:
                //------------------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //-----------
                    // Nivel 3x2:
                    //-----------
                    BotonNivel(
                      pFilas: 3,
                      pColumnas: 2,
                      pNivel: 0,
                      pCallBackFunction: () {
                        setState(() {
                          InfoJuego.nivelSeleccionado = 0;
                          InfoJuego.filasSeleccionadas = 3;
                          InfoJuego.columnasSeleccionadas = 2;
                        });
                      },
                    ),

                    //-----------
                    // Nivel 4x3:
                    //-----------
                    BotonNivel(
                      pFilas: 4,
                      pColumnas: 3,
                      pNivel: 1,
                      pCallBackFunction: () {
                        setState(() {
                          InfoJuego.nivelSeleccionado = 1;
                          InfoJuego.filasSeleccionadas = 4;
                          InfoJuego.columnasSeleccionadas = 3;
                        });
                      },
                    ),

                    //-----------
                    // Nivel 5x4:
                    //-----------
                    BotonNivel(
                      pFilas: 5,
                      pColumnas: 4,
                      pNivel: 2,
                      pCallBackFunction: () {
                        setState(() {
                          InfoJuego.nivelSeleccionado = 2;
                          InfoJuego.filasSeleccionadas = 5;
                          InfoJuego.columnasSeleccionadas = 4;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                //------------------------------------------------------------------
                // Segunda fila de niveles de juego:
                //------------------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //-----------
                    // Nivel 6x5:
                    //-----------
                    BotonNivel(
                      pFilas: 6,
                      pColumnas: 5,
                      pNivel: 3,
                      pCallBackFunction: () {
                        setState(() {
                          InfoJuego.nivelSeleccionado = 3;
                          InfoJuego.filasSeleccionadas = 6;
                          InfoJuego.columnasSeleccionadas = 5;
                        });
                      },
                    ),

                    //-----------
                    // Nivel 8x7:
                    //-----------
                    BotonNivel(
                      pFilas: 8,
                      pColumnas: 7,
                      pNivel: 4,
                      pCallBackFunction: () {
                        setState(() {
                          InfoJuego.nivelSeleccionado = 4;
                          InfoJuego.filasSeleccionadas = 8;
                          InfoJuego.columnasSeleccionadas = 7;
                        });
                      },
                    ),

                    //-----------
                    // Nivel 9x8:
                    //-----------
                    BotonNivel(
                      pFilas: 9,
                      pColumnas: 8,
                      pNivel: 5,
                      pCallBackFunction: () {
                        setState(() {
                          InfoJuego.nivelSeleccionado = 5;
                          InfoJuego.filasSeleccionadas = 9;
                          InfoJuego.columnasSeleccionadas = 8;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                //------------------------------------------------------------------
                // Botón para comenzar a jugar
                //------------------------------------------------------------------
                WidBotonStandard(
                  pTexto: SrvTraducciones.get('comenzar_juego'),
                  pTipoDeLetra: 'Luckiest Guy',
                  pTamanyoLetra: 28,
                  pColorLetra: Colores.segundo,
                  pSombra: true,
                  pEsquinasRedondeadas: true,
                  pFuncionSonido: SrvSonidos.play,
                  pNavegarA: '/game',
                ),

                const SizedBox(height: 25),

                //------------------------------------------------------------------
                // Botón para ir a la configuración
                //------------------------------------------------------------------
                WidBotonStandard(
                  pTexto: SrvTraducciones.get('configuracion'),
                  pTipoDeLetra: 'Chewy',
                  pTamanyoLetra: 16,
                  pColorLetra: Colores.tercero,
                  pIcono: Icons.settings,
                  pColorIcono: Colores.tercero,
                  pSombra: true,
                  pEsquinasRedondeadas: true,
                  pNavegarA: '/config',
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
    bool estaSeleccionado = pNumBoton == InfoJuego.temaSeleccionado;
    File primeraImagenTema = SrvImagenes.obtenerUnaImagen(pListaImagenes, "01.png");

    return ElevatedButton(
      onPressed: () {
        SrvSonidos.level();
        pCallBackFunction();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: estaSeleccionado ? Colores.segundo : null,
        foregroundColor: Colores.onPrimero,
        elevation: estaSeleccionado ? 15 : 10,
      ),
      child: Image.file(primeraImagenTema, width: 60, height: 60, fit: BoxFit.contain),
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
    bool estaSeleccionado = pNivel == InfoJuego.nivelSeleccionado;

    return AnimatedScale(
      scale: estaSeleccionado ? 1.2 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      child: ElevatedButton(
        onPressed: () async {
          SrvSonidos.level();
          pCallBackFunction();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          backgroundColor: estaSeleccionado ? Colores.segundo : Colores.primero,
          foregroundColor: Colores.onPrimero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: estaSeleccionado ? 15 : 10,
        ),
        child: Text(titulo, style: Textos.textStyleYellow30, textAlign: TextAlign.center),
      ),
    );
  }
}
