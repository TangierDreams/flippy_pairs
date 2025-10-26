import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> widJuegoAcabado(
  BuildContext context,
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
                  colors: [Colores.quinto, Colores.primero],
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
                        ? SrvTraducciones.get('excelente')
                        : pPuntosPartida < 0
                        ? SrvTraducciones.get('ops')
                        : SrvTraducciones.get('empate'),
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 36,
                      color: Colores.blanco,
                      shadows: [Shadow(blurRadius: 6, color: Colores.fondo, offset: const Offset(2, 2))],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${SrvTraducciones.get('nivel')}: $pNivel',
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 28,
                      color: Colores.segundo,
                      shadows: [Shadow(blurRadius: 6, color: Colores.fondo, offset: const Offset(2, 2))],
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
                    style: GoogleFonts.baloo2(fontSize: 20, color: Colores.blanco, fontWeight: FontWeight.bold),
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
                              style: GoogleFonts.baloo2(fontSize: tamanyoTexto, color: Colores.blanco),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 40, // Define el ancho del círculo (ajusta según necesites)
                              height: 40, // Define la altura del círculo (debe ser igual al ancho)
                              alignment: Alignment.center, // Centra el texto dentro del círculo
                              decoration: BoxDecoration(
                                color: Colores.segundo, // Color de fondo del círculo (naranja oscuro)
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
                                  color: Colors.white,
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
                              style: GoogleFonts.baloo2(fontSize: tamanyoTexto, color: Colores.blanco),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              pPartidasDelNivel.toString(),
                              style: GoogleFonts.baloo2(fontSize: tamanyoTexto, color: Colores.blanco),
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
                              style: GoogleFonts.baloo2(fontSize: tamanyoTexto, color: Colores.blanco),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              pPuntosDelNivel.toString(),
                              style: GoogleFonts.baloo2(fontSize: tamanyoTexto, color: Colores.blanco),
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
                              style: GoogleFonts.baloo2(fontSize: tamanyoTexto, color: Colores.blanco),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(pTiempoPartida, style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco)),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                            child: Text(
                              SrvTraducciones.get('tiempo_medio'),
                              style: GoogleFonts.baloo2(fontSize: tamanyoTexto, color: Colores.blanco),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(pTiempoMedio, style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco)),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                            child: Text(
                              SrvTraducciones.get('tiempo_record'),
                              style: GoogleFonts.baloo2(fontSize: tamanyoTexto, color: Colores.blanco),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(pTiempoRecord, style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco)),
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
                          backgroundColor: Colores.cuarto,
                          foregroundColor: Colores.blanco,
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
                        child: Text(SrvTraducciones.get('volver_a_jugar'), style: GoogleFonts.baloo2(fontSize: 18)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colores.segundo,
                          foregroundColor: Colores.blanco,
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
                        child: Text(SrvTraducciones.get('salir'), style: GoogleFonts.baloo2(fontSize: 18)),
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
