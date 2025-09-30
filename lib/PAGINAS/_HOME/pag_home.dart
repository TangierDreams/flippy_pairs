import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';

// Variables globales:

int filasSeleccionadas = 3;
int columnasSeleccionadas = 2;

class PagHome extends StatefulWidget {
  const PagHome({super.key});

  @override
  State<PagHome> createState() => _PagHomeState();
}

class _PagHomeState extends State<PagHome> {
  int nivelSeleccionado = 0;

  // Lista de niveles a seleccionar:

  final niveles = const [
    {"titulo": "3x2", "filas": 3, "columnas": 2},
    {"titulo": "4x3", "filas": 4, "columnas": 3},
    {"titulo": "5x4", "filas": 5, "columnas": 4},
    {"titulo": "6x5", "filas": 6, "columnas": 5},
    {"titulo": "8x7", "filas": 8, "columnas": 7},
    {"titulo": "9x8", "filas": 9, "columnas": 8},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Toolbar:
      appBar: WidToolbar(showMenuButton: false, showBackButton: false, subtitle: "Harden Your Mind Once and for All!"),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Difficulty', textAlign: TextAlign.center, style: Textos.textStyleOrange30),

            const SizedBox(height: 15),

            // Generamos dinámicamente los botones en 2 filas:
            for (int row = 0; row < 2; row++) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (col) {
                  final index = row * 3 + col;
                  final nivel = niveles[index];
                  return BotonDeNivel(
                    pTitulo: nivel["titulo"] as String,
                    pFilas: nivel["filas"] as int,
                    pColumnas: nivel["columnas"] as int,
                    pSeleccionado: nivelSeleccionado == index,
                    pAlPresionar: () {
                      setState(() {
                        nivelSeleccionado = index;
                        filasSeleccionadas = nivel["filas"] as int;
                        columnasSeleccionadas = nivel["columnas"] as int;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],

            BotonJugar(),
          ],
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------
// Botón Play
//------------------------------------------------------------------------------
class BotonJugar extends StatelessWidget {
  const BotonJugar({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Sonidos.play();

        // Esperamos un poco para que se perciba el sonido
        await Future.delayed(const Duration(milliseconds: 300));

        if (context.mounted) {
          Navigator.of(
            context,
          ).pushNamed('/game', arguments: {'pRows': filasSeleccionadas, 'pCols': columnasSeleccionadas});
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        backgroundColor: Colores.primary,
        foregroundColor: Colores.contrast,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
      ),

      child: Text('Start Playing!', style: Textos.textStyleOrange28, textAlign: TextAlign.center),
    );
  }
}

//------------------------------------------------------------------------------
// Boton de nivel.
//------------------------------------------------------------------------------
class BotonDeNivel extends StatelessWidget {
  final String pTitulo;
  final int pFilas;
  final int pColumnas;
  final bool pSeleccionado;
  final VoidCallback pAlPresionar;

  const BotonDeNivel({
    super.key,
    required this.pTitulo,
    required this.pFilas,
    required this.pColumnas,
    required this.pSeleccionado,
    required this.pAlPresionar,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: pSeleccionado ? 1.2 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      child: ElevatedButton(
        onPressed: () async {
          Sonidos.level();
          pAlPresionar();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          backgroundColor: pSeleccionado ? Colors.orange : Colores.primary,
          foregroundColor: Colores.contrast,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: pSeleccionado ? 15 : 10,
        ),
        child: Text(pTitulo, style: Textos.textStyleYellow30, textAlign: TextAlign.center),
      ),
    );
  }
}
