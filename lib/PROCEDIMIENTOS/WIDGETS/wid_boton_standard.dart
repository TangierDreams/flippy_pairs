import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidBotonStandard extends StatelessWidget {
  //boton:
  final Color? pColorDeFondo;
  final bool pEsquinasRedondeadas;
  final bool pSombra;
  final bool pEmitirSonido;
  final VoidCallback? pFuncionSonido;
  final String? pNavegarA;
  final VoidCallback? pFuncionCallBack;

  //texto:
  final String pTexto;
  final String pTipoDeLetra;
  final double pTamanyoLetra;
  final bool pLetraBold;
  final Color? pColorLetra;

  //icono:
  final IconData? pIcono;
  final Color? pColorIcono;
  final double pTamanyoIcono;

  const WidBotonStandard({
    super.key,
    //boton:
    this.pColorDeFondo,
    this.pEsquinasRedondeadas = false,
    this.pSombra = false,
    this.pEmitirSonido = true,
    this.pFuncionSonido,
    this.pNavegarA,
    this.pFuncionCallBack,

    //texto:
    required this.pTexto,
    this.pTipoDeLetra = 'Roboto',
    this.pTamanyoLetra = 14,
    this.pLetraBold = false,
    this.pColorLetra,

    //icono:
    this.pIcono,
    this.pColorIcono,
    this.pTamanyoIcono = 25,
  });

  @override
  Widget build(BuildContext context) {
    final Color colorDeFondo = pColorDeFondo ?? SrvColores.get(context, 'primero');
    final Color colorLetra = pColorLetra ?? SrvColores.get(context, 'onPrimero');
    final Color colorIcono = pColorIcono ?? SrvColores.get(context, 'onPrimero');
    return ElevatedButton(
      onPressed: () async {
        if (pEmitirSonido) {
          if (pFuncionSonido != null) {
            pFuncionSonido!();
          } else {
            SrvSonidos.boton();
          }
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
        backgroundColor: colorDeFondo,
        foregroundColor: colorLetra,
        shape: pEsquinasRedondeadas
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: pSombra ? 10 : null,
      ),

      child: pIcono != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(pIcono, color: colorIcono, size: pTamanyoIcono),

                const SizedBox(width: 12),

                Text(
                  pTexto,
                  style: GoogleFonts.getFont(
                    pTipoDeLetra,
                    textStyle: TextStyle(
                      color: colorLetra,
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
                  color: colorLetra,
                  fontSize: pTamanyoLetra,
                  fontWeight: pLetraBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              textAlign: TextAlign.center,
            ),
    );
  }
}
