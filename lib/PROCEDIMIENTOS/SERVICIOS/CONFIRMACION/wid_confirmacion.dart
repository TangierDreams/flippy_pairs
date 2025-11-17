import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidConfirmacion extends StatelessWidget {
  //Ventana:
  final Color pBackgroundColor;
  //Titulo:
  final String pTitulo;
  final String pTituloFont;
  final double pTituloSize;
  final Color pTituloColor;
  final bool pTituloBold;
  //Descripción:
  final String pDescripcion;
  final String pDescripcionFont;
  final double pDescripcionSize;
  final Color pDescripcionColor;
  final bool pDescripcionBold;
  //Imagen:
  final Widget? pImagen;
  final double pImagenWidth;
  final double pImagenHeight;
  //Botones:
  final bool pDosBotones;
  final bool pSonidoBotones;
  //Boton Ok:
  final String pBotonOkTexto;
  final String pBotonOkFont;
  final double pBotonOkSize;
  final Color pBotonOkColorFondo;
  final Color pBotonOkColor;
  final bool pBotonOkBold;
  //Boton Ko:
  final String pBotonKoTexto;
  final String pBotonKoFont;
  final double pBotonKoSize;
  final Color pBotonKoColorFondo;
  final Color pBotonKoColor;
  final bool pBotonKoBold;
  //Acción a realizar:
  final VoidCallback? pOnConfirmar;

  const WidConfirmacion({
    super.key,
    //Ventana:
    required this.pBackgroundColor,
    //Titulo:
    required this.pTitulo,
    required this.pTituloFont,
    required this.pTituloSize,
    required this.pTituloColor,
    required this.pTituloBold,
    //Descripción:
    required this.pDescripcion,
    required this.pDescripcionFont,
    required this.pDescripcionSize,
    required this.pDescripcionColor,
    required this.pDescripcionBold,
    //Imagen:
    this.pImagen,
    required this.pImagenWidth,
    required this.pImagenHeight,
    //Botones:
    required this.pDosBotones,
    required this.pSonidoBotones,
    //Boton OK:
    required this.pBotonOkTexto,
    required this.pBotonOkFont,
    required this.pBotonOkSize,
    required this.pBotonOkColorFondo,
    required this.pBotonOkColor,
    required this.pBotonOkBold,
    //Boton KO:
    required this.pBotonKoTexto,
    required this.pBotonKoFont,
    required this.pBotonKoSize,
    required this.pBotonKoColorFondo,
    required this.pBotonKoColor,
    required this.pBotonKoBold,
    //Acción a realizar
    this.pOnConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: pBackgroundColor,
      title: Text(
        pTitulo,
        style: GoogleFonts.getFont(
          pTituloFont,
          textStyle: TextStyle(
            color: pTituloColor,
            fontSize: pTituloSize,
            fontWeight: pTituloBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pImagen != null) ...[
            SizedBox(width: pImagenWidth, height: pImagenHeight, child: pImagen!),
            SizedBox(width: 16),
          ],
          Expanded(
            child: Text(
              pDescripcion,
              style: GoogleFonts.getFont(
                pDescripcionFont,
                textStyle: TextStyle(
                  color: pDescripcionColor,
                  fontSize: pDescripcionSize,
                  fontWeight: pDescripcionBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: _buildBotones(context),
    );
  }

  List<Widget> _buildBotones(BuildContext context) {
    if (!pDosBotones) {
      return [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: pBotonOkColorFondo,
            //foregroundColor: pBotonOkColor,
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
          child: Text(
            pBotonOkTexto,
            style: GoogleFonts.getFont(
              pBotonOkFont,
              textStyle: TextStyle(
                color: pBotonOkColor,
                fontSize: pBotonOkSize,
                fontWeight: pBotonOkBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          onPressed: () {
            if (pSonidoBotones) SrvSonidos.boton();
            Navigator.of(context).pop();
            pOnConfirmar?.call();
          },
        ),
      ];
    }

    return [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: pBotonKoColorFondo,
          //foregroundColor: pBotonOkColor,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: Text(
          pBotonKoTexto,
          style: GoogleFonts.getFont(
            pBotonKoFont,
            textStyle: TextStyle(
              color: pBotonKoColor,
              fontSize: pBotonKoSize,
              fontWeight: pBotonKoBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        onPressed: () {
          if (pSonidoBotones) SrvSonidos.boton();
          Navigator.of(context).pop();
        },
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: pBotonOkColorFondo,
          //foregroundColor: pBotonOkColor,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: Text(
          pBotonOkTexto,
          style: GoogleFonts.getFont(
            pBotonOkFont,
            textStyle: TextStyle(
              color: pBotonOkColor,
              fontSize: pBotonOkSize,
              fontWeight: pBotonOkBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        onPressed: () {
          if (pSonidoBotones) SrvSonidos.boton();
          Navigator.of(context).pop();
          pOnConfirmar?.call();
        },
      ),
    ];
  }
}
