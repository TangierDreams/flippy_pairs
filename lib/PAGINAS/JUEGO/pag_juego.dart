//==============================================================================
// MODULO DE UI DEL JUEGO.
//==============================================================================

//import 'dart:ui';
import 'package:flippy_pairs/PAGINAS/JUEGO/srv_juego.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_contador.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_carta.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_cronometro.dart';

class PagJuego extends StatefulWidget {
  const PagJuego({super.key});

  @override
  State<PagJuego> createState() => _PagJuegoState();
}

class _PagJuegoState extends State<PagJuego> {
  bool _juegoInicializado = false;

  @override
  void initState() {
    super.initState();
    _inicializarPantalla();
  }

  void _inicializarPantalla() async {
    await Future.microtask(() {});
    if (!mounted) return;

    // Inicializar el juego con las variables globales

    inicializarJuego(InfoJuego.filasSeleccionadas, InfoJuego.columnasSeleccionadas);

    setState(() {
      _juegoInicializado = true;
    });
  }

  @override
  void dispose() {
    //timerKey.currentState?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_juegoInicializado) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: WidToolbar(showMenuButton: false, showBackButton: true, subtitle: "Harden Your Mind Once and for All!"),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Contadores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WidContador(pTexto: "Points", pContador: puntosPartida, pModo: 1),
              WidContador(pTexto: "Match", pContador: parejasAcertadas, pModo: 1),
              WidContador(pTexto: "Fail", pContador: parejasFalladas, pModo: 2),
              WidCronometro(key: cronometroKey),
              //WidTemporizador(key: timerKey, pModo: 1),
            ],
          ),

          //--------------------------------------------------------------------
          // Grid de cartas
          //--------------------------------------------------------------------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnas,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: cartasTotales,
                itemBuilder: (context, index) {
                  return WidCarta(
                    pEstaBocaArriba: cartasGiradas[index] || cartasEmparejadas[index],
                    pImagenCarta: imagenes[index],
                    pDestello: cartasDestello.contains(index),

                    //----------------------------------------------------------
                    // A cada carta, le pasamos una función de callback para que
                    // al pulsarla hagamos lo siguiente:
                    // - Emitir un sonido
                    // - Manejar la logica de pulsar una carta
                    // - Controlar si ha acabado el juego
                    //----------------------------------------------------------
                    pCallBackFunction: () async {
                      SrvSonidos.flip();
                      await manejarToqueCarta(index, setState);
                      if (context.mounted) {
                        await controlJuegoAcabado(context, setState);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
