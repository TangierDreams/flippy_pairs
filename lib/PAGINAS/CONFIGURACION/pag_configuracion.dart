//------------------------------------------------------------------------------
// PAGINA DONDE MOSTRAMOS LAS OPCIONES DE CONFIGURACION DEL JUEGO.
//------------------------------------------------------------------------------

import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_confirmacion.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_dispositivo.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_datos_generales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_idiomas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_supabase.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_boton_standard.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_idiomas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class PagConfiguracion extends StatefulWidget {
  const PagConfiguracion({super.key});

  @override
  State<PagConfiguracion> createState() => _PagConfiguracionState();
}

class _PagConfiguracionState extends State<PagConfiguracion> {
  final FocusNode _focusNodeAlias = FocusNode();
  final TextEditingController _nombreUsuario = TextEditingController();
  bool _sonidoActivado = true;
  bool _musicaActivada = true;

  @override
  void initState() {
    super.initState();

    //----------
    // Montamos este listener para grabar el alias del usuario cuando el campo
    // donde pedimos este dato pierda el foco
    //----------
    _focusNodeAlias.addListener(() {
      if (!_focusNodeAlias.hasFocus) {
        SrvDiskette.guardarValor(DisketteKey.deviceName, _nombreUsuario.text);
        SrvLogger.grabarLog('pag_configuracion', 'addListener()', 'deviceName guardado: ${_nombreUsuario.text}');
      }
    });

    SrvLogger.grabarLog('pag_configuracion', 'initState()', 'Entramos en la pagina de configuracion');
    _cargarDatos();
  }

  @override
  void dispose() {
    _focusNodeAlias.dispose();
    _nombreUsuario.dispose();
    SrvLogger.grabarLog('pag_configuracion', 'dispose()', 'Salimos de la pagina de configuracion');
    super.dispose();
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
            showBackButton: true,
            subtitle: SrvTraducciones.get('subtitulo_app'),
          ),

          //resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //------------------------------------------------------------------
                  // Pedimos el alias del usuario
                  //------------------------------------------------------------------
                  Text(
                    SrvTraducciones.get('texto_alias'),
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 20,
                      color: SrvColores.get(context, ColorKey.principal),
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          color: SrvColores.get(context, ColorKey.fondo),
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nombreUsuario,
                    focusNode: _focusNodeAlias,
                    inputFormatters: [LengthLimitingTextInputFormatter(25)],
                    style: GoogleFonts.luckiestGuy(color: SrvColores.get(context, ColorKey.texto), fontSize: 16),
                    decoration: InputDecoration(
                      labelText: SrvTraducciones.get('alias'),
                      labelStyle: GoogleFonts.luckiestGuy(
                        color: SrvColores.get(context, ColorKey.destacado),
                        fontSize: 18,
                      ),
                      hintText: SrvTraducciones.get('alias_hint'),
                      hintStyle: GoogleFonts.luckiestGuy(
                        color: SrvColores.get(context, ColorKey.principal).withValues(alpha: 0.7),
                        fontSize: 14,
                      ),

                      // 1. Define the default border style
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: SrvColores.get(context, ColorKey.principal), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),

                      // 2. Define the focused border style (when the user taps it)
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: SrvColores.get(context, ColorKey.principal), width: 3.0),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //------------------------------------------------------------------
                  // Activar o desactivar sonidos
                  //------------------------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        SrvTraducciones.get('activar_sonidos'),
                        style: GoogleFonts.luckiestGuy(
                          fontSize: 16,
                          color: SrvColores.get(context, ColorKey.principal),
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: SrvColores.get(context, ColorKey.fondo),
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        activeThumbColor: SrvColores.get(context, ColorKey.destacado),
                        activeTrackColor: SrvColores.get(context, ColorKey.principal),
                        // 1. Valor actual del estado
                        value: _sonidoActivado,
                        // 2. Función que se llama cuando el usuario toca el switch
                        onChanged: (bool newValue) {
                          SrvSonidos.boton();
                          // Actualiza el estado y redibuja la interfaz
                          setState(() {
                            _sonidoActivado = newValue;
                            SrvDiskette.guardarValor(DisketteKey.sonidoActivado, _sonidoActivado);
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  //------------------------------------------------------------
                  // Activar o desactivar música
                  //------------------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        SrvTraducciones.get('activar_musica'),
                        style: GoogleFonts.luckiestGuy(
                          fontSize: 16,
                          color: SrvColores.get(context, ColorKey.principal),
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: SrvColores.get(context, ColorKey.fondo),
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        activeThumbColor: SrvColores.get(context, ColorKey.destacado),
                        activeTrackColor: SrvColores.get(context, ColorKey.principal),
                        // 1. Valor actual del estado
                        value: _musicaActivada,
                        // 2. Función que se llama cuando el usuario toca el switch
                        onChanged: (bool newValue) {
                          SrvSonidos.boton();
                          // Actualiza el estado y redibuja la interfaz
                          setState(() {
                            _musicaActivada = newValue;
                            SrvDiskette.guardarValor(DisketteKey.musicaActivada, _musicaActivada);
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  //-----------------------------------------
                  // Aquí llamamos al widget de pedir idioma:
                  //-----------------------------------------
                  WidIdiomas(
                    pLabel: SrvTraducciones.get('selec_idioma'),
                    pColorLabel: SrvColores.get(context, ColorKey.principal),
                    pTipoDeLetra: "Luckiest Guy",
                    pTamanyoLetra: 16,
                    pColorLetra: SrvColores.get(context, ColorKey.texto),
                  ),

                  const SizedBox(height: 10),

                  //---------------------------------------
                  // Botón para eliminar mi puntuación:
                  //---------------------------------------
                  WidBotonStandard(
                    pTexto: SrvTraducciones.get('eliminar_mis_puntuaciones'),
                    pTipoDeLetra: 'Chewy',
                    pTamanyoLetra: 18,
                    pColorDeFondo: SrvColores.get(context, ColorKey.muyResaltado),
                    pColorLetra: SrvColores.get(context, ColorKey.onMuyResaltado),
                    pEmitirSonido: true,
                    pEsquinasRedondeadas: true,
                    pFuncionCallBack: () => SrvConfirmacion.confirmacion(
                      context: context,
                      pTitulo: SrvTraducciones.get('borrar_puntuacion'),
                      pTituloFont: 'Luckiest Guy',
                      pDescripcion: SrvTraducciones.get('seguro_eliminar_puntos'),
                      pDescripcionFont: 'Chewy',
                      pBotonOkTexto: SrvTraducciones.get('borrar'),
                      pBotonOkFont: 'Chewy',
                      pBotonOkColor: SrvColores.get(context, ColorKey.muyResaltado),
                      pBotonKoTexto: SrvTraducciones.get('salir'),
                      pBotonKoFont: 'Chewy',
                      pOnConfirmar: () {
                        // 1. Eliminamos los registros:
                        SrvSupabase.borrarPuntosUsuario(SrvDiskette.leerValor(DisketteKey.deviceId));

                        // 2. Mostrar toast de confirmación:
                        Fluttertoast.showToast(
                          msg: SrvTraducciones.get('puntuaciones_eliminadas'),
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: SrvColores.get(context, ColorKey.principal),
                          textColor: SrvColores.get(context, ColorKey.onPrincipal),
                          fontSize: 16.0,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  //---------------------------------------
                  // Botón para mostrar el archivo de logs:
                  //---------------------------------------
                  if (SrvDatosGenerales.logsActivados)
                    WidBotonStandard(
                      pTexto: 'Ver registro de logs',
                      pColorDeFondo: SrvColores.get(context, ColorKey.principal),
                      pColorLetra: SrvColores.get(context, ColorKey.onPrincipal),
                      pEmitirSonido: true,
                      pEsquinasRedondeadas: true,
                      pNavegarA: '/logs',
                    ),

                  const SizedBox(height: 10),

                  //-------------------------------------------------
                  // Botón para generar una nueva id del dispositivo:
                  //-------------------------------------------------
                  if (SrvDatosGenerales.logsActivados)
                    WidBotonStandard(
                      pTexto: 'Cambiar Id',
                      pEsquinasRedondeadas: true,
                      pFuncionCallBack: () => {SrvDispositivo.obtenerId2()},
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _cargarDatos() {
    _nombreUsuario.text = SrvDiskette.leerValor(DisketteKey.deviceName, defaultValue: '');
    _sonidoActivado = SrvDiskette.leerValor(DisketteKey.sonidoActivado, defaultValue: true);
    _musicaActivada = SrvDiskette.leerValor(DisketteKey.musicaActivada, defaultValue: true);
  }
}
