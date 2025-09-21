import 'package:flippy_pairs/SHARED/SERVICES/srv_dialog.dart';
import 'package:flippy_pairs/SHARED/SERVICES/srv_game_control.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_card.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_drawer.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_toolbar.dart';

class PagGame extends StatefulWidget {
  const PagGame({super.key});

  @override
  State<PagGame> createState() => _PagGameState();
}

class _PagGameState extends State<PagGame> {
  late int pRows;
  late int pCols;
  late SrvGameControl game;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    pRows = args['pRows'];
    pCols = args['pCols'];
  }


  @override
  void initState() {
    super.initState();
    // 3x2, 4x3, 5x4, 6x5, 8x7, 9x8.
    game = SrvGameControl(rows: pRows, cols: pCols);
  }


  void _checkForWin() {
    if (game.hasWon) {
      SrvDialog.showQuestionDialog(
        context: context,
        title: 'You won! 🎉',
        message: 'Great job! Do you want to play again?',
        negativeText: 'Close',
        positiveText: 'Play again',
        onPositive: () {
          setState(() => game.resetGame());
        },
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidToolbar(
        showMenuButton: true,
        showBackButton: false,
        showCloseButton: false,
        subtitle: "Harden Your Mind Once and for All!",
        extraActions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => game.resetGame()),
          ),
        ],
      ),
      drawer: WidDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: game.cols,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: game.totalCards,
          itemBuilder: (context, index) {
            return WidCard(
              isFaceUp: game.cardsUp[index] || game.matched[index],
              frontIcon: game.icons[index],
              onTap: () async {
                final result = await game.onCardTap(index, setState);
                if (result == true) _checkForWin();
              },
            );
          },
        ),
      ),
    );
  }
}
