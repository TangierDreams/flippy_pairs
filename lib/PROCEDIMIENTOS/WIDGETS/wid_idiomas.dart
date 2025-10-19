import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_idiomas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidIdiomas extends StatefulWidget {
  const WidIdiomas({super.key});

  @override
  State<WidIdiomas> createState() => WidIdiomasState();
}

class WidIdiomasState extends State<WidIdiomas> {
  // Idiomas a seleccionar:

  final List<Map<String, String>> _idiomasDisponibles = const [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'ca', 'name': 'Català'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'pt', 'name': 'Português'},
    {'code': 'it', 'name': 'Italiano'},
  ];

  String? _idiomaActual;

  @override
  void initState() {
    super.initState();
    _idiomaActual = SrvDiskette.leerValor(DisketteKey.idioma, defaultValue: "en");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Seleccione un idioma",
          style: GoogleFonts.luckiestGuy(
            fontSize: 16,
            color: Colores.primero,
            shadows: [Shadow(blurRadius: 6, color: Colores.fondo, offset: const Offset(2, 2))],
          ),
        ),

        DropdownButton<String>(
          // En el combo mostramos el valor actual del idioma:
          value: _idiomaActual,

          // Icono de la flecha
          icon: const Icon(Icons.language),

          // Estilo del texto
          style: GoogleFonts.luckiestGuy(
            fontSize: 16,
            color: Colores.negro,
            shadows: [Shadow(blurRadius: 6, color: Colores.fondo, offset: const Offset(2, 2))],
          ),

          // Montamos la lista de idiomas:
          items: _idiomasDisponibles.map<DropdownMenuItem<String>>((Map<String, String> idioma) {
            return DropdownMenuItem<String>(value: idioma['code'], child: Text(idioma['name']!));
          }).toList(),

          // Función que se ejecuta cuando el usuario selecciona una nueva opción:
          onChanged: (String? nuevoIdioma) {
            SrvSonidos.boton();
            _idiomaActual = nuevoIdioma!;
            SrvIdiomas.cambiarIdioma(nuevoIdioma);
          },
        ),
      ],
    );
  }
}
