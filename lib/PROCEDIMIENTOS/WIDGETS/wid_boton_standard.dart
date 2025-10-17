import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidBotonStandard extends StatelessWidget {
  //boton:
  final Color pColorDeFondo;
  final bool pEsquinasRedondeadas;
  final bool pSombra;
  final bool pEmitirSonido;
  final String? pNavegarA;
  final VoidCallback? pFuncionCallBack;

  //texto:
  final String pTexto;
  final String pTipoDeLetra;
  final double pTamanyoLetra;
  final bool pLetraBold;
  final Color pColorLetra;

  //icono:
  final IconData? pIcono;
  final Color pColorIcono;
  final double pTamanyoIcono;

  const WidBotonStandard({
    super.key,
    //boton:
    this.pColorDeFondo = Colores.primero,
    this.pEsquinasRedondeadas = false,
    this.pSombra = false,
    this.pEmitirSonido = true,
    this.pNavegarA,
    this.pFuncionCallBack,

    //texto:
    required this.pTexto,
    this.pTipoDeLetra = 'Roboto',
    this.pTamanyoLetra = 14,
    this.pLetraBold = false,
    this.pColorLetra = Colores.onPrimero,

    //icono:
    this.pIcono,
    this.pColorIcono = Colores.onPrimero,
    this.pTamanyoIcono = 25,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (pEmitirSonido) {
          SrvSonidos.play();
          await Future.delayed(const Duration(milliseconds: 300));
        }
        if (pFuncionCallBack != null) {
          pFuncionCallBack!();
        } else if (pNavegarA != null) {
          if (context.mounted) {
            Navigator.of(context).pushNamed(pNavegarA!);
          }
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        backgroundColor: pColorDeFondo,
        foregroundColor: pColorLetra,
        shape: pEsquinasRedondeadas
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: pSombra ? 10 : null,
      ),

      child: pIcono != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(pIcono, color: pColorIcono, size: pTamanyoIcono),

                const SizedBox(width: 12),

                Text(
                  pTexto,
                  style: GoogleFonts.getFont(
                    pTipoDeLetra,
                    textStyle: TextStyle(
                      color: pColorLetra,
                      fontSize: pTamanyoLetra,
                      fontWeight: pLetraBold ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Text(
              pTexto,
              style: GoogleFonts.getFont(
                pTipoDeLetra,
                textStyle: TextStyle(
                  color: pColorLetra,
                  fontSize: pTamanyoLetra,
                  fontWeight: pLetraBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              textAlign: TextAlign.center,
            ),
    );
  }
}
