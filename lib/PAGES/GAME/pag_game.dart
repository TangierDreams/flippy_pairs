import 'package:flippy_pairs/SHARED/SERVICES/srv_game_control.dart';
import 'package:flippy_pairs/SHARED/SERVICES/srv_sounds.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_counter.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_game_over.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_card.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_toolbar.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_timer.dart';

class PagGame extends StatefulWidget {
  const PagGame({super.key});

  @override
  State<PagGame> createState() => _PagGameState();
}

class _PagGameState extends State<PagGame> {
  // Definimos las variables de estado:

  late int pRows;
  late int pCols;
  SrvGameControl? srvGameControl;

  // Este objeto nos permite acceder desde aquí a los métodos definidos en el
  // widget WidTimer, como start, stop o dispose:

  final GlobalKey<WidTimerState> _widTimerKey = GlobalKey<WidTimerState>();

  // Introducimos este objeto para poder hacer un flash de las cartas cuando
  // hacen match:

  final Set<int> _flashingIndices = <int>{};

  @override
  void initState() {
    super.initState();

    // Inicializamos el juego:

    _initializeGame();
  }

  void _initializeGame() async {
    // Detenemos la ejecución de "_initializeGame" hasta el siguiente ciclo para
    // asegurarnos de que el contexto está listo para ser usado.

    await Future.microtask(() {});

    // Si después del "Future" no tenemos el contexto, nos vamos:

    if (!mounted) {
      return;
    }

    // Cargamos la lista de argumentos del widget:

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    pRows = args['pRows'];
    pCols = args['pCols'];

    // Instanciamos el control del juego y reconstruimos la UI:

    setState(() {
      srvGameControl = SrvGameControl(rows: pRows, cols: pCols);
    });

    // Este método es más seguro que "Future.Microtask":
    // (Sobre todo si estamos esperando la creación de otro widget)

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _widTimerKey.currentState?.start();
      }
    });
  }

  // Si nos vamos de la página, nos cargamos el _timer:

  @override
  void dispose() {
    _widTimerKey.currentState?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mostramos un spinner mientras se inicializa el control de juego:

    if (srvGameControl == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Montamos la pantalla principal del juego:

    return Scaffold(
      appBar: WidToolbar(showMenuButton: false, showBackButton: true, subtitle: "Harden Your Mind Once and for All!"),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WidCounter(text: "Points: ", counter: srvGameControl!.points, mode: 1),
              WidCounter(text: "Match: ", counter: srvGameControl!.matchedPairsCount, mode: 1),
              WidCounter(text: "Fail: ", counter: srvGameControl!.failedPairsCount, mode: 2),
              WidTimer(key: _widTimerKey, mode: 1),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: srvGameControl!.cols,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: srvGameControl!.totalCardsCount,
                itemBuilder: (context, index) {
                  return WidCard(
                    isFaceUp: srvGameControl!.cardsUp[index] || srvGameControl!.matched[index],
                    frontIcon: srvGameControl!.icons[index],
                    onTap: () async {
                      // Cuando presionamos sobre una carta:

                      final result = await srvGameControl!.onCardTap(index, setState);

                      // Check if the tap resulted in a match (srvGameControl.isMatch is a new hypothetical property)
                      // NOTE: If srvGameControl is designed well, it should tell us which two cards were matched.
                      // Assuming srvGameControl can tell us the indices of the last two matched cards:

                      if (srvGameControl!.isLastMoveAMatch) {
                        // You'll need a way for SrvGameControl to expose this

                        // 1. Get the indices of the recently matched pair (you'll need to update SrvGameControl to expose this)
                        final matchedIndices = srvGameControl!.lastFlippedCards;

                        // 2. Start the Flash
                        setState(() {
                          _flashingIndices.addAll(matchedIndices);
                        });

                        SrvSounds().emitLevelSound();

                        // 3. Wait a short duration for the "flash" effect
                        await Future.delayed(const Duration(milliseconds: 800));

                        // 4. Stop the Flash and Rebuild
                        if (mounted) {
                          setState(() {
                            _flashingIndices.clear(); // Clear the indices to stop the flash
                            matchedIndices.clear();
                          });
                        }
                      } else {
                        if (srvGameControl!.isLastMoveAnError) {
                          SrvSounds().emitGobackSound();
                        }
                      }

                      if (result == true) {
                        // Si hemos acabado la partida:

                        if (srvGameControl!.hasWon) {
                          //Paramos el timer:

                          _widTimerKey.currentState?.stop();

                          // Esperamos medio segundo antes de mostrar un pop-up:

                          await Future.delayed(const Duration(milliseconds: 500));

                          // Mostramos el "WidGameOver" al final del juego:

                          if (context.mounted) {
                            widGameOver(
                              context,
                              srvGameControl!.gamePoints,
                              srvGameControl!.points,
                              _widTimerKey.currentState!.formattedTime,

                              // Si hemos pulsado "Play again", reseteamos el juego y el timer:
                              onPlayAgain: () {
                                setState(() {
                                  srvGameControl!.resetGame();
                                  _widTimerKey.currentState?.reset();
                                  _widTimerKey.currentState?.start();
                                });
                              },
                            );
                          }
                        }
                      }
                    },

                    // NEW: Pass the boolean flag indicating if this specific card should flash.
                    isFlashing: _flashingIndices.contains(index),
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
