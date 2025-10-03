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
                ElevatedButton(
                  onPressed: () {
                    InfoJuego.listaSeleccionada = "iconos";
                  },
                  child: Image.asset('assets/imagenes/iconos/01.png', width: 60, height: 60, fit: BoxFit.contain),
                ),
                ElevatedButton(
                  onPressed: () {
                    InfoJuego.listaSeleccionada = "animales";
                  },
                  child: Image.asset('assets/imagenes/animales/01.png', width: 60, height: 60, fit: BoxFit.contain),
                ),
                ElevatedButton(
                  onPressed: () {
                    InfoJuego.listaSeleccionada = "retratos";
                  },
                  child: Image.asset('assets/imagenes/retratos/01.png', width: 60, height: 60, fit: BoxFit.contain),
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
                ElevatedButton(
                  onPressed: () {
                    InfoJuego.listaSeleccionada = "coches";
                  },
                  child: Image.asset('assets/imagenes/coches/01.png', width: 60, height: 60, fit: BoxFit.contain),
                ),
                ElevatedButton(
                  onPressed: () {
                    InfoJuego.listaSeleccionada = "herramientas";
                  },
                  child: Image.asset('assets/imagenes/herramientas/01.png', width: 60, height: 60, fit: BoxFit.contain),
                ),
                ElevatedButton(
                  onPressed: () {
                    InfoJuego.listaSeleccionada = "ciudades";
                  },
                  child: Image.asset('assets/imagenes/ciudades/01.png', width: 60, height: 60, fit: BoxFit.contain),
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
