import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_idiomas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_idiomas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    _focusNodeAlias.addListener(() {
      if (!_focusNodeAlias.hasFocus) {
        // El usuario ha salido del campo, guardamos el alias
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
          //Toolbar:
          appBar: WidToolbar(showMenuButton: false, showBackButton: true, subtitle: SrvIdiomas.get('subtitulo_app')),

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
                    SrvIdiomas.get('texto_alias'),
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 20,
                      color: Colores.primero,
                      shadows: [Shadow(blurRadius: 6, color: Colores.fondo, offset: const Offset(2, 2))],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nombreUsuario,
                    focusNode: _focusNodeAlias,
                    inputFormatters: [LengthLimitingTextInputFormatter(25)],
                    style: GoogleFonts.luckiestGuy(color: Colors.black, fontSize: 16),
                    decoration: InputDecoration(
                      labelText: SrvIdiomas.get('alias'),
                      labelStyle: GoogleFonts.luckiestGuy(color: Colores.segundo, fontSize: 18),
                      hintText: SrvIdiomas.get('alias_hint'),
                      hintStyle: GoogleFonts.luckiestGuy(color: Colores.primero.withValues(alpha: 0.7), fontSize: 14),

                      // 1. Define the default border style
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colores.primero, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),

                      // 2. Define the focused border style (when the user taps it)
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colores.primero, width: 3.0),
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
                        SrvIdiomas.get('activar_sonidos'),
                        style: GoogleFonts.luckiestGuy(
                          fontSize: 16,
                          color: Colores.primero,
                          shadows: [Shadow(blurRadius: 6, color: Colores.fondo, offset: const Offset(2, 2))],
                        ),
                      ),
                      Switch(
                        activeThumbColor: Colors.white,
                        activeTrackColor: Colors.black,
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

                  //------------------------------------------------------------------
                  // Activar o desactivar música
                  //------------------------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        SrvIdiomas.get('activar_musica'),
                        style: GoogleFonts.luckiestGuy(
                          fontSize: 16,
                          color: Colores.primero,
                          shadows: [Shadow(blurRadius: 6, color: Colores.fondo, offset: const Offset(2, 2))],
                        ),
                      ),
                      Switch(
                        activeThumbColor: Colors.white,
                        activeTrackColor: Colors.black,
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
                  const SizedBox(height: 15),

                  //------------------------
                  // Aquí pedimos el idioma:
                  //------------------------
                  WidIdiomas(),

                  const SizedBox(height: 15),

                  //------------------------------------------------------------------
                  // Botón de confirmación de datos
                  //------------------------------------------------------------------
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     _guardarDatos(context);
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     side: const BorderSide(
                  //       color: Colores.primero, // Specify the color of the border
                  //       width: 4.0, // Specify the thickness of the border
                  //     ),
                  //   ),
                  //   // START OF MODIFIED CHILD
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min, // Essential: Keeps the Row size to its children
                  //     children: <Widget>[
                  //       // 1. Add the Diskette (Save) Icon
                  //       const Icon(
                  //         Icons.save,
                  //         color: Colores.segundo, // Match the text color
                  //         size: 25, // Adjust size as needed
                  //       ),

                  //       // 2. Add a small space between the icon and the text
                  //       const SizedBox(width: 12),

                  //       // 3. Keep your existing Text widget
                  //       Text(
                  //         SrvIdiomas.get('grabar_datos'),
                  //         style: GoogleFonts.luckiestGuy(
                  //           fontSize: 16,
                  //           color: Colores.segundo,
                  //           shadows: [Shadow(blurRadius: 6, color: Colores.fondo, offset: const Offset(2, 2))],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  //   // END OF MODIFIED CHILD
                  // ),
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

  // void _guardarDatos(BuildContext pContexto) async {
  //   SrvDiskette.guardarValor(DisketteKey.deviceName, _nombreUsuario.text);
  //   SrvDiskette.guardarValor(DisketteKey.sonidoActivado, _sonidoActivado);
  //   SrvDiskette.guardarValor(DisketteKey.musicaActivada, _musicaActivada);
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(SrvIdiomas.get('datos_guardados'))));
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   await SrvSonidos.goback();
  //   await Future.delayed(const Duration(milliseconds: 250));
  //   if (pContexto.mounted) {
  //     Navigator.pop(pContexto);
  //   }
  // }
}
