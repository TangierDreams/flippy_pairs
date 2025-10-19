import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_idiomas.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> widJuegoAcabado(
  BuildContext context,
  int pPuntosPartida,
  int pPuntosDelNivel,
  int pPartidasDelNivel,
  String pTiempoPartida,
  String pTiempoMedio,
  String pTiempoRecord, {
  VoidCallback? pFuncionDeCallback,
}) async {
  bool gana = pPuntosPartida > 0 ? true : false;

  // 🔊 Reproducir sonido divertido según resultado
  if (gana) {
    SrvSonidos.sucess(); // o el sonido de victoria que tengas
  } else {
    SrvSonidos.error(); // o uno de error divertido
  }

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: SrvIdiomas.get('fin_del_juego'),
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
                    gana ? SrvIdiomas.get('excelente') : SrvIdiomas.get('ops'),
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 36,
                      color: Colores.blanco,
                      shadows: [Shadow(blurRadius: 6, color: Colores.fondo, offset: const Offset(2, 2))],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    gana
                        ? SrvIdiomas.get('has_ganado', pArgumento: pPuntosPartida.toString())
                        : SrvIdiomas.get('has_perdido', pArgumento: pPuntosPartida.abs().toString()),
                    style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco),
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
                              SrvIdiomas.get('partidas_jugadas'),
                              style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              pPartidasDelNivel.toString(),
                              style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                            child: Text(
                              SrvIdiomas.get('puntuacion_total'),
                              style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              pPuntosDelNivel.toString(),
                              style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                            child: Text(
                              SrvIdiomas.get('finalizado_en'),
                              style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco),
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
                              SrvIdiomas.get('tiempo_medio'),
                              style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco),
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
                              SrvIdiomas.get('tiempo_record'),
                              style: GoogleFonts.baloo2(fontSize: 18, color: Colores.blanco),
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
                          Navigator.of(context).pop();
                          if (pFuncionDeCallback != null) {
                            pFuncionDeCallback();
                          }
                        },
                        child: Text(SrvIdiomas.get('volver_a_jugar'), style: GoogleFonts.baloo2(fontSize: 18)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colores.segundo,
                          foregroundColor: Colores.blanco,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {
                          SrvSonidos.goback();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text(SrvIdiomas.get('salir'), style: GoogleFonts.baloo2(fontSize: 18)),
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
