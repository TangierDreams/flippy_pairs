import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_supabase.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidResumen extends StatefulWidget {
  //final int pNivel;

  const WidResumen({super.key});

  @override
  State<WidResumen> createState() => WidResumenState();
}

class WidResumenState extends State<WidResumen> {
  int partidas = 0;
  int puntos = 0;
  int posicion = 0;

  // Control de carga de datos
  bool datosListos = false;

  @override
  void initState() {
    super.initState();
    // Al iniciar el widget, cargamos los datos
    //refrescarDatos();
  }

  // Función pública para que la página pueda llamar y refrescar los datos al empezar un nuevo juego

  Future<void> refrescarDatos() async {
    // Aquí llamas a Supabase
    final datos = await SrvSupabase.obtenerRegFlippy(
      pId: SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: ''),
    );

    final nivel = datos.firstWhere(
      (reg) => reg['nivel'] == InfoJuego.nivelSeleccionado,
      orElse: () => <String, dynamic>{},
    );

    final pos = await SrvSupabase.obtenerRankingFlippy(
      pId: SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: ''),
      pLevel: InfoJuego.nivelSeleccionado,
    );

    if (mounted) {
      setState(() {
        partidas = nivel['partidas'] ?? 0;
        puntos = nivel['puntos'] ?? 0;
        posicion = pos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String descNivel = InfoJuego.niveles[InfoJuego.nivelSeleccionado]['titulo'] as String;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colores.quinto, Colores.primero],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colores.primero, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            descNivel,
            style: GoogleFonts.comicNeue(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colores.segundo,
              shadows: [const Shadow(color: Colores.primero, blurRadius: 3, offset: Offset(2, 2))],
            ),
          ),
          Text(
            "Partidas: $partidas",
            style: GoogleFonts.comicNeue(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colores.blanco,
              shadows: [const Shadow(color: Colores.primero, blurRadius: 3, offset: Offset(2, 2))],
            ),
          ),
          Text(
            "Puntos: $puntos",
            style: GoogleFonts.comicNeue(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colores.blanco,
              shadows: [const Shadow(color: Colores.primero, blurRadius: 3, offset: Offset(2, 2))],
            ),
          ),
          Text(
            "CMF: $posicion",
            style: GoogleFonts.comicNeue(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colores.blanco,
              shadows: [const Shadow(color: Colores.primero, blurRadius: 3, offset: Offset(2, 2))],
            ),
          ),
        ],
      ),
    );
  }
}
