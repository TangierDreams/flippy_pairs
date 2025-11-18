// import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
// import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/CONFIRMACION/wid_confirmacion.dart';
// import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
// import 'package:flutter/material.dart';

// class SrvConfirmacion {
//   //----------------------------------------------------------------------------
//   // Pedimos una confirmación al usuario.
//   //----------------------------------------------------------------------------
//   static Future<bool?> confirmacion({
//     required BuildContext context,
//     //Ventana:
//     Color? pBackgroundColor,
//     bool? pModal, // NUEVO: controla si el diálogo es modal
//     //Titulo:
//     required String pTitulo,
//     String? pTituloFont,
//     double? pTituloSize,
//     Color? pTituloColor,
//     bool? pTituloBold,
//     //Descripción:
//     required String pDescripcion,
//     String? pDescripcionFont,
//     double? pDescripcionSize,
//     Color? pDescripcionColor,
//     bool? pDescripcionBold,
//     //Imagen:
//     Widget? pImagen,
//     double? pImagenWidth,
//     double? pImagenHeight,
//     //Botones:
//     bool? pDosBotones,
//     bool? pSonidoBotones,
//     //Boton Ok:
//     String? pBotonOkTexto,
//     String? pBotonOkFont,
//     double? pBotonOkSize,
//     Color? pBotonOkColorFondo,
//     Color? pBotonOkColor,
//     bool? pBotonOkBold,
//     //Boton Ko:
//     String? pBotonKoTexto,
//     String? pBotonKoFont,
//     double? pBotonKoSize,
//     Color? pBotonKoColorFondo,
//     Color? pBotonKoColor,
//     bool? pBotonKoBold,
//     //Acción a realizar:
//     VoidCallback? pOnConfirmar,
//   }) {
//     return showDialog<bool>(
//       context: context,
//       barrierDismissible: !(pModal ?? false), // NUEVO: controla si se cierra tocando fuera
//       builder: (context) => WidConfirmacion(
//         //Ventana:
//         pBackgroundColor: pBackgroundColor ?? SrvColores.get(context, ColorKey.fondo),
//         //Titulo:
//         pTitulo: pTitulo,
//         pTituloFont: pTituloFont ?? 'Roboto',
//         pTituloSize: pTituloSize ?? 22,
//         pTituloColor: pTituloColor ?? SrvColores.get(context, ColorKey.principal),
//         pTituloBold: pTituloBold ?? true,
//         //Descripción:
//         pDescripcion: pDescripcion,
//         pDescripcionFont: pDescripcionFont ?? 'Roboto',
//         pDescripcionSize: pDescripcionSize ?? 14,
//         pDescripcionColor: pDescripcionColor ?? SrvColores.get(context, ColorKey.texto),
//         pDescripcionBold: pDescripcionBold ?? false,
//         //Imagen:
//         pImagen: pImagen,
//         pImagenWidth: pImagenWidth ?? 20,
//         pImagenHeight: pImagenHeight ?? 20,
//         //Botones:
//         pDosBotones: pDosBotones ?? true,
//         pSonidoBotones: pSonidoBotones ?? true,
//         //Boton Ok:
//         pBotonOkTexto: pBotonOkTexto ?? SrvTraducciones.get('aceptar'),
//         pBotonOkFont: pBotonOkFont ?? 'Roboto',
//         pBotonOkSize: pBotonOkSize ?? 14,
//         pBotonOkColorFondo: pBotonOkColorFondo ?? SrvColores.get(context, ColorKey.contrasteFondo),
//         pBotonOkColor: pBotonOkColor ?? SrvColores.get(context, ColorKey.destacado),
//         pBotonOkBold: pBotonOkBold ?? false,
//         //Boton Ko:
//         pBotonKoTexto: pBotonKoTexto ?? SrvTraducciones.get('cancelar'),
//         pBotonKoFont: pBotonKoFont ?? 'Roboto',
//         pBotonKoSize: pBotonKoSize ?? 14,
//         pBotonKoColorFondo: pBotonKoColorFondo ?? SrvColores.get(context, ColorKey.contrasteFondo),
//         pBotonKoColor: pBotonKoColor ?? SrvColores.get(context, ColorKey.texto),
//         pBotonKoBold: pBotonKoBold ?? false,
//         pOnConfirmar: pOnConfirmar,
//       ),
//     );
//   }
// }

import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/CONFIRMACION/wid_confirmacion.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
import 'package:flutter/material.dart';

class SrvConfirmacion {
  //----------------------------------------------------------------------------
  // Pedimos una confirmación al usuario.
  //----------------------------------------------------------------------------
  static Future<bool?> confirmacion({
    required BuildContext context,
    //Ventana:
    Color? pBackgroundColor,
    bool? pModal,
    //Titulo:
    required String pTitulo,
    String? pTituloFont,
    double? pTituloSize,
    Color? pTituloColor,
    bool? pTituloBold,
    //Descripción:
    required String pDescripcion,
    String? pDescripcionFont,
    double? pDescripcionSize,
    Color? pDescripcionColor,
    bool? pDescripcionBold,
    //Imagen:
    Widget? pImagen,
    double? pImagenWidth,
    double? pImagenHeight,
    //Botones:
    bool? pDosBotones,
    bool? pSonidoBotones,
    //Boton Ok:
    String? pBotonOkTexto,
    String? pBotonOkFont,
    double? pBotonOkSize,
    Color? pBotonOkColorFondo,
    Color? pBotonOkColor,
    bool? pBotonOkBold,
    //Boton Ko:
    String? pBotonKoTexto,
    String? pBotonKoFont,
    double? pBotonKoSize,
    Color? pBotonKoColorFondo,
    Color? pBotonKoColor,
    bool? pBotonKoBold,
    //Acción a realizar:
    VoidCallback? pOnConfirmar,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: !(pModal ?? false), // NUEVO: controla si se cierra tocando fuera
      builder: (context) => WidConfirmacion(
        //Ventana:
        pBackgroundColor: pBackgroundColor ?? SrvColores.get(context, ColorKey.fondo),
        //Titulo:
        pTitulo: pTitulo,
        pTituloFont: pTituloFont ?? 'Roboto',
        pTituloSize: pTituloSize ?? 22,
        pTituloColor: pTituloColor ?? SrvColores.get(context, ColorKey.principal),
        pTituloBold: pTituloBold ?? true,
        //Descripción:
        pDescripcion: pDescripcion,
        pDescripcionFont: pDescripcionFont ?? 'Roboto',
        pDescripcionSize: pDescripcionSize ?? 14,
        pDescripcionColor: pDescripcionColor ?? SrvColores.get(context, ColorKey.texto),
        pDescripcionBold: pDescripcionBold ?? false,
        //Imagen:
        pImagen: pImagen,
        pImagenWidth: pImagenWidth ?? 20,
        pImagenHeight: pImagenHeight ?? 20,
        //Botones:
        pDosBotones: pDosBotones ?? true,
        pSonidoBotones: pSonidoBotones ?? true,
        //Boton Ok:
        pBotonOkTexto: pBotonOkTexto ?? SrvTraducciones.get('aceptar'),
        pBotonOkFont: pBotonOkFont ?? 'Roboto',
        pBotonOkSize: pBotonOkSize ?? 14,
        pBotonOkColorFondo: pBotonOkColorFondo ?? SrvColores.get(context, ColorKey.contrasteFondo),
        pBotonOkColor: pBotonOkColor ?? SrvColores.get(context, ColorKey.destacado),
        pBotonOkBold: pBotonOkBold ?? false,
        //Boton Ko:
        pBotonKoTexto: pBotonKoTexto ?? SrvTraducciones.get('cancelar'),
        pBotonKoFont: pBotonKoFont ?? 'Roboto',
        pBotonKoSize: pBotonKoSize ?? 14,
        pBotonKoColorFondo: pBotonKoColorFondo ?? SrvColores.get(context, ColorKey.contrasteFondo),
        pBotonKoColor: pBotonKoColor ?? SrvColores.get(context, ColorKey.texto),
        pBotonKoBold: pBotonKoBold ?? false,
        pOnConfirmar: pOnConfirmar,
      ),
    );
  }
}
