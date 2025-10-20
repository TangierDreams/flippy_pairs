import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_idiomas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidIdiomas extends StatefulWidget {
  final String pLabel;
  final Color pColorLabel;
  final String pTipoDeLetra;
  final double pTamanyoLetra;
  final bool pLetraBold;
  final Color pColorLetra;
  final bool pEmitirSonido;
  final VoidCallback? pFuncionSonido;

  const WidIdiomas({
    super.key,
    required this.pLabel,
    this.pColorLabel = Colores.primero,
    this.pTipoDeLetra = 'Roboto',
    this.pTamanyoLetra = 14,
    this.pLetraBold = false,
    this.pColorLetra = Colores.negro,
    this.pEmitirSonido = true,
    this.pFuncionSonido,
  });

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
          widget.pLabel,
          // style: GoogleFonts.luckiestGuy(
          //   fontSize: 16,
          //   color: Colores.primero,
          //   shadows: [Shadow(blurRadius: 6, color: Colores.fondo, offset: const Offset(2, 2))],
          // ),
          style: GoogleFonts.getFont(
            widget.pTipoDeLetra,
            textStyle: TextStyle(
              color: widget.pColorLabel,
              fontSize: widget.pTamanyoLetra,
              fontWeight: widget.pLetraBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),

        DropdownButton<String>(
          value: _idiomaActual,
          icon: const Icon(Icons.language),

          style: GoogleFonts.getFont(
            widget.pTipoDeLetra,
            textStyle: TextStyle(
              color: widget.pColorLetra,
              fontSize: widget.pTamanyoLetra,
              fontWeight: widget.pLetraBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),

          // Montamos la lista de idiomas:
          items: _idiomasDisponibles.map<DropdownMenuItem<String>>((Map<String, String> idioma) {
            return DropdownMenuItem<String>(value: idioma['code'], child: Text(idioma['name']!));
          }).toList(),

          // Función que se ejecuta cuando el usuario selecciona una nueva opción:
          onChanged: (String? nuevoIdioma) async {
            SrvSonidos.boton();
            if (widget.pEmitirSonido) {
              if (widget.pFuncionSonido != null) {
                widget.pFuncionSonido!();
              } else {
                SrvSonidos.boton();
              }
              await Future.delayed(const Duration(milliseconds: 300));
            }

            _idiomaActual = nuevoIdioma!;
            SrvIdiomas.cambiarIdioma(nuevoIdioma);
          },
        ),
      ],
    );
  }
}
