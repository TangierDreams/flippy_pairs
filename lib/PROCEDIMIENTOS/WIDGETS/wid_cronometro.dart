import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_cronometro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';

// --------------------------------------------------------------------------
// INSTANCE OF THE MANAGER
// --------------------------------------------------------------------------
// Create a static reference to the manager that can be used globally.
//final CronometroManager cronometroManager = CronometroManager();

// --------------------------------------------------------------------------
// CLASE PRINCIPAL DEL WIDGET (Now a StatelessWidget, or kept as StatefulWidget
// if you want to use the dispose logic, but StatelessWidget is cleaner here)
// --------------------------------------------------------------------------

class WidCronometro extends StatelessWidget {
  const WidCronometro({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos a los cambios en SrvCronometro.tiempEnMMSS para modificar la UI.
    return ValueListenableBuilder<String>(
      valueListenable: SrvCronometro.tiempoEnMMSS,
      builder: (context, tiempoEnMMSS, child) {
        return Container(
          width: 70,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colores.quinto,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colores.primero, width: 3),
            boxShadow: [
              BoxShadow(color: Colores.primero, blurRadius: 8, offset: const Offset(4, 4)),
              BoxShadow(color: Colores.blanco, blurRadius: 4, offset: Offset(-2, -2)),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Timer',
                style: GoogleFonts.comicNeue(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colores.blanco,
                  shadows: [Shadow(color: Colores.primero, blurRadius: 3, offset: const Offset(2, 2))],
                  //color: Colors.white,
                ),
              ),
              // Use the time string provided by the ValueListenableBuilder
              Text(
                tiempoEnMMSS,
                style: GoogleFonts.comicNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colores.blanco,
                  shadows: [Shadow(color: Colores.primero, blurRadius: 3, offset: const Offset(2, 2))],
                  //color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
