import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fuentes.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> widJuegoAcabado(
  BuildContext context,
  int msgAleatorio,
  String pNivel,
  int pPuntosPartida,
  int pPosicionFlippy,
  int pPuntosDelNivel,
  int pPartidasDelNivel,
  String pTiempoPartida,
  String pTiempoMedio,
  String pTiempoRecord, {
  VoidCallback? pFuncionDeCallback,
}) async {
  //bool gana = pPuntosPartida > 0 ? true : false;
  double tamanyoTexto = 16;
  bool botonSalirActivado = true;
  bool botonJugarActivado = true;

  // Reproducir sonido de victoria o derrota:

  if (pPuntosPartida > 0) {
    SrvSonidos.sucess();
  } else {
    if (pPuntosPartida < 0) {
      SrvSonidos.error();
    } else {
      SrvSonidos.draw();
    }
  }

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: SrvTraducciones.get('fin_del_juego'),
    transitionDuration: const Duration(milliseconds: 800),
    pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
    transitionBuilder: (context, anim1, anim2, child) {
      // Animación combinada: escala + opacidad
      return Transform.scale(
        scale: Curves.elasticOut.transform(anim1.value),
        child: Opacity(
          opacity: anim1.value,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [SrvColores.get(context, ColorKey.apoyo), SrvColores.get(context, ColorKey.principal)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pPuntosPartida > 0
                        ? SrvTraducciones.get('ganada$msgAleatorio')
                        : pPuntosPartida < 0
                        ? SrvTraducciones.get('perdida$msgAleatorio')
                        : SrvTraducciones.get('empatada$msgAleatorio'),
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 36,
                      color: SrvColores.get(context, ColorKey.onPrincipal),
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
                  const SizedBox(height: 2),
                  Text(
                    '${SrvTraducciones.get('nivel')}: $pNivel',
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 28,
                      color: SrvColores.get(context, ColorKey.destacado),
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

                  const SizedBox(height: 2),
                  Text(
                    pPuntosPartida > 0
                        ? SrvTraducciones.get('has_ganado', pArgumento: pPuntosPartida.toString())
                        : pPuntosPartida < 0
                        ? SrvTraducciones.get('has_perdido', pArgumento: pPuntosPartida.abs().toString())
                        : SrvTraducciones.get('has_empatado'),
                    style: GoogleFonts.baloo2(
                      fontSize: 20,
                      color: SrvColores.get(context, ColorKey.onPrincipal),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2.5), // Columna de descripción
                      1: FlexColumnWidth(1), // Columna de valores
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                            child: Text(
                              SrvTraducciones.get('pos_flippy'),
                              style: GoogleFonts.baloo2(
                                fontSize: tamanyoTexto,
                                color: SrvColores.get(context, ColorKey.onPrincipal),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 40, // Define el ancho del círculo (ajusta según necesites)
                              height: 40, // Define la altura del círculo (debe ser igual al ancho)
                              alignment: Alignment.center, // Centra el texto dentro del círculo
                              decoration: BoxDecoration(
                                color: SrvColores.get(
                                  context,
                                  ColorKey.destacado,
                                ), // Color de fondo del círculo (naranja oscuro)
                                shape: BoxShape.circle, // Forma circular
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3), // Sombra para que destaque
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                pPosicionFlippy.toString(),
                                style: GoogleFonts.baloo2(
                                  fontSize: 20,
                                  // Usamos un color que contraste bien con el naranja, como blanco o un color claro
                                  color: SrvColores.get(context, ColorKey.onPrincipal),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                            child: Text(
                              SrvTraducciones.get('partidas_jugadas'),
                              style: GoogleFonts.baloo2(
                                fontSize: tamanyoTexto,
                                color: SrvColores.get(context, ColorKey.onPrincipal),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              pPartidasDelNivel.toString(),
                              style: GoogleFonts.baloo2(
                                fontSize: tamanyoTexto,
                                color: SrvColores.get(context, ColorKey.onPrincipal),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                            child: Text(
                              SrvTraducciones.get('puntuacion_total'),
                              style: GoogleFonts.baloo2(
                                fontSize: tamanyoTexto,
                                color: SrvColores.get(context, ColorKey.onPrincipal),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              pPuntosDelNivel.toString(),
                              style: GoogleFonts.baloo2(
                                fontSize: tamanyoTexto,
                                color: SrvColores.get(context, ColorKey.onPrincipal),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                            child: Text(
                              SrvTraducciones.get('finalizado_en'),
                              style: GoogleFonts.baloo2(
                                fontSize: tamanyoTexto,
                                color: SrvColores.get(context, ColorKey.onPrincipal),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              pTiempoPartida,
                              style: GoogleFonts.baloo2(
                                fontSize: 18,
                                color: SrvColores.get(context, ColorKey.onPrincipal),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                            child: Text(
                              SrvTraducciones.get('tiempo_medio'),
                              style: GoogleFonts.baloo2(
                                fontSize: tamanyoTexto,
                                color: SrvColores.get(context, ColorKey.onPrincipal),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              pTiempoMedio,
                              style: GoogleFonts.baloo2(
                                fontSize: 18,
                                color: SrvColores.get(context, ColorKey.onPrincipal),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                            child: Text(
                              SrvTraducciones.get('tiempo_record'),
                              style: GoogleFonts.baloo2(
                                fontSize: tamanyoTexto,
                                color: SrvColores.get(context, ColorKey.onPrincipal),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              pTiempoRecord,
                              style: GoogleFonts.baloo2(
                                fontSize: 18,
                                color: SrvColores.get(context, ColorKey.onPrincipal),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SrvColores.get(context, ColorKey.muyResaltado),
                          foregroundColor: SrvColores.get(context, ColorKey.onPrincipal),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {
                          if (botonJugarActivado) {
                            botonJugarActivado = false;
                            SrvSonidos.boton();
                            Navigator.of(context).pop();
                            if (pFuncionDeCallback != null) {
                              pFuncionDeCallback();
                            }
                          }
                        },
                        child: Text(
                          SrvTraducciones.get('volver_a_jugar'),
                          style: SrvFuentes.chewy(
                            context,
                            18,
                            SrvColores.get(context, ColorKey.onPrincipal),
                            pColorSombra: SrvColores.get(context, ColorKey.muyResaltado),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SrvColores.get(context, ColorKey.destacado),
                          foregroundColor: SrvColores.get(context, ColorKey.onPrincipal),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {
                          if (botonSalirActivado) {
                            botonSalirActivado = false;
                            SrvSonidos.boton();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          SrvTraducciones.get('salir'),
                          style: SrvFuentes.chewy(
                            context,
                            18,
                            SrvColores.get(context, ColorKey.onPrincipal),
                            pColorSombra: SrvColores.get(context, ColorKey.destacado),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
