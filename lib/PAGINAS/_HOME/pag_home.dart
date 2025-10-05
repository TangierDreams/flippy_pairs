import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';

class PagHome extends StatefulWidget {
  const PagHome({super.key});

  @override
  State<PagHome> createState() => _PagHomeState();
}

class _PagHomeState extends State<PagHome> {
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
            Text("Themes", textAlign: TextAlign.center, style: Textos.textStyleOrange30),

            const SizedBox(height: 15),

            //------------------------------------------------------------------
            // Primera línea de imagenes
            //------------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BotonTema(
                  pListaSeleccionada: "iconos",
                  pImagen: 'assets/imagenes/iconos/01.png',
                  pSeleccionado: InfoJuego.temaSeleccionado == 0,
                  pNumBoton: 0,
                ),

                BotonTema(
                  pListaSeleccionada: "animales",
                  pImagen: 'assets/imagenes/animales/01.png',
                  pSeleccionado: InfoJuego.temaSeleccionado == 1,
                  pNumBoton: 1,
                ),

                BotonTema(
                  pListaSeleccionada: "retratos",
                  pImagen: 'assets/imagenes/retratos/01.png',
                  pSeleccionado: InfoJuego.temaSeleccionado == 2,
                  pNumBoton: 2,
                ),
              ],
            ),

            const SizedBox(height: 15),

            //------------------------------------------------------------------
            // Segunda línea de imagenes
            //------------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BotonTema(
                  pListaSeleccionada: "herramientas",
                  pImagen: 'assets/imagenes/herramientas/01.png',
                  pSeleccionado: InfoJuego.temaSeleccionado == 3,
                  pNumBoton: 3,
                ),

                BotonTema(
                  pListaSeleccionada: "coches",
                  pImagen: 'assets/imagenes/coches/01.png',
                  pSeleccionado: InfoJuego.temaSeleccionado == 4,
                  pNumBoton: 4,
                ),

                BotonTema(
                  pListaSeleccionada: "logos",
                  pImagen: 'assets/imagenes/logos/01.png',
                  pSeleccionado: InfoJuego.temaSeleccionado == 5,
                  pNumBoton: 5,
                ),
              ],
            ),

            const SizedBox(height: 25),

            Text('Difficulty', textAlign: TextAlign.center, style: Textos.textStyleOrange30),

            const SizedBox(height: 15),

            //------------------------------------------------------------------
            // Las 2 filas con los niveles de juego
            //------------------------------------------------------------------
            for (int row = 0; row < 2; row++) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (col) {
                  final index = row * 3 + col;
                  final nivel = InfoJuego.niveles[index];
                  return BotonDeNivel(
                    pTitulo: nivel["titulo"] as String,
                    pFilas: nivel["filas"] as int,
                    pColumnas: nivel["columnas"] as int,
                    pSeleccionado: InfoJuego.nivelSeleccionado == index,
                    pAlPresionar: () {
                      setState(() {
                        InfoJuego.nivelSeleccionado = index;
                        InfoJuego.filasSeleccionadas = nivel["filas"] as int;
                        InfoJuego.columnasSeleccionadas = nivel["columnas"] as int;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],

            //------------------------------------------------------------------
            // Botón para comenzar a jugar
            //------------------------------------------------------------------
            BotonJugar(),
          ],
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------
// Botón Tema
//------------------------------------------------------------------------------
class BotonTema extends StatelessWidget {
  final String pImagen;
  final String pListaSeleccionada;
  final bool pSeleccionado;
  final int pNumBoton;

  const BotonTema({
    super.key,
    required this.pImagen,
    required this.pListaSeleccionada,
    required this.pSeleccionado,
    required this.pNumBoton,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Sonidos.level();
        InfoJuego.listaSeleccionada = pListaSeleccionada;
        InfoJuego.temaSeleccionado = pNumBoton;
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: pSeleccionado ? Colores.segundo : null,
        foregroundColor: Colores.onPrimero,
        elevation: pSeleccionado ? 15 : 10,
      ),
      child: Image.asset(pImagen, width: 60, height: 60, fit: BoxFit.contain),
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
          backgroundColor: pSeleccionado ? Colores.segundo : Colores.primero,
          foregroundColor: Colores.onPrimero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: pSeleccionado ? 15 : 10,
        ),
        child: Text(pTitulo, style: Textos.textStyleYellow30, textAlign: TextAlign.center),
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
          Navigator.of(context).pushNamed(
            '/game',
            //arguments: {'pRows': InfoJuego.filasSeleccionadas, 'pCols': InfoJuego.columnasSeleccionadas},
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        backgroundColor: Colores.primero,
        foregroundColor: Colores.onPrimero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
      ),

      child: Text('Start Playing!', style: Textos.textStyleOrange28, textAlign: TextAlign.center),
    );
  }
}
