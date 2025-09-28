import 'package:flippy_pairs/SHARED/SERVICES/srv_game_control.dart';
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
  late int pRows;
  late int pCols;
  SrvGameControl? srvGameControl;
  final GlobalKey<WidTimerState> _timerKey = GlobalKey<WidTimerState>();

  @override
  void initState() {
    super.initState();

    // We can’t read ModalRoute arguments here directly, so we defer:

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      pRows = args['pRows'];
      pCols = args['pCols'];

      setState(() {
        srvGameControl = SrvGameControl(rows: pRows, cols: pCols);
      });

      // Ensure the WidTimer is instantiated in the widget tree before starting:
      WidgetsBinding.instance.addPostFrameCallback((__) {
        _timerKey.currentState?.start();
      });
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  //   pRows = args['pRows'];
  //   pCols = args['pCols'];

  //   srvGameControl = SrvGameControl(rows: pRows, cols: pCols);
  // }

  @override
  Widget build(BuildContext context) {
    // While waiting for arguments
    if (srvGameControl == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: WidToolbar(showMenuButton: false, showBackButton: true, subtitle: "Harden Your Mind Once and for All!"),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WidCounter(text: "Points: ", counter: srvGameControl!.points, mode: 1),
              WidCounter(text: "Match: ", counter: srvGameControl!.matchedPairs, mode: 1),
              WidCounter(text: "Fail: ", counter: srvGameControl!.failedPairs, mode: 2),
              WidTimer(key: _timerKey, mode: 1),
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
                itemCount: srvGameControl!.totalCards,
                itemBuilder: (context, index) {
                  return WidCard(
                    isFaceUp: srvGameControl!.cardsUp[index] || srvGameControl!.matched[index],
                    frontIcon: srvGameControl!.icons[index],
                    onTap: () async {
                      final result = await srvGameControl!.onCardTap(index, setState);
                      if (result == true) {
                        if (srvGameControl!.hasWon) {
                          _timerKey.currentState?.stop(); // stop timer
                          await Future.delayed(const Duration(milliseconds: 500));
                          if (context.mounted) {
                            widGameOver(
                              context,
                              true,
                              onPlayAgain: () {
                                setState(() {
                                  srvGameControl!.resetGame();
                                  _timerKey.currentState?.reset(); // reset timer
                                  _timerKey.currentState?.start(); // restart timer if you want auto-start
                                });
                              },
                            );
                          }
                        }
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
