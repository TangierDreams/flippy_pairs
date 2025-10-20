//==============================================================================
// MODULO DE UI DEL JUEGO.
//==============================================================================

import 'package:flippy_pairs/PAGINAS/JUEGO/srv_juego.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_contador.dart';
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
    SrvLogger.grabarLog('pag_juego', 'initState()', 'Entramos en la pagina de jugar');
    _inicializarPantalla();
  }

  @override
  void dispose() async {
    await SrvSonidos.detenerMusicaFondo();
    InfoJuego.musicaActiva = false;
    SrvLogger.grabarLog('pag_juego', 'dispose()', 'Salimos de la pagina de jugar');
    super.dispose();
  }

  void _inicializarPantalla() async {
    await Future.microtask(() {});
    if (!mounted) return;

    // Inicializar el juego con las variables globales

    SrvJuego.inicializarJuego(InfoJuego.filasSeleccionadas, InfoJuego.columnasSeleccionadas);

    setState(() {
      _juegoInicializado = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_juegoInicializado) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: WidToolbar(showMenuButton: false, showBackButton: true, subtitle: SrvTraducciones.get('subtitulo_app')),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Contadores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WidContador(pTexto: SrvTraducciones.get('puntos'), pContador: SrvJuego.puntosPartida, pModo: 1),
              WidContador(pTexto: SrvTraducciones.get('aciertos'), pContador: SrvJuego.parejasAcertadas, pModo: 1),
              WidContador(pTexto: SrvTraducciones.get('errores'), pContador: SrvJuego.parejasFalladas, pModo: 2),
              WidCronometro(),
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
                  crossAxisCount: SrvJuego.columnas,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: SrvJuego.cartasTotales,
                itemBuilder: (context, index) {
                  return WidCarta(
                    pEstaBocaArriba: SrvJuego.listaDeCartasGiradas[index] || SrvJuego.listaDeCartasEmparejadas[index],
                    pImagenCarta: SrvJuego.listaDeImagenes[index],
                    pDestello: SrvJuego.cartasDestello.contains(index),

                    //----------------------------------------------------------
                    // A cada carta, le pasamos una función de callback para que
                    // al pulsarla hagamos lo siguiente:
                    // - Emitir un sonido
                    // - Manejar la logica de pulsar una carta
                    // - Controlar si ha acabado el juego
                    //----------------------------------------------------------
                    pCallBackFunction: () async {
                      await SrvJuego.cartaPulsada(index, setState);
                      if (context.mounted) {
                        await SrvJuego.controlJuegoAcabado(context, setState);
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
