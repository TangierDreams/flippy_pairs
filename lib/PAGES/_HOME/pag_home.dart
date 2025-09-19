import 'package:flippy_pairs/SHARED/data/dat_icons.dart';
import 'package:flippy_pairs/SHARED/widgets/wid_card.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/SHARED/widgets/wid_drawer.dart';
import 'package:flippy_pairs/SHARED/widgets/wid_toolbar.dart';

class PagHome extends StatefulWidget {
  const PagHome({super.key,});

  @override
  State<PagHome> createState() => _PagHomeState();

}

class _PagHomeState extends State<PagHome> {

  static const int gridSize = 4;
  final int pairCount = (gridSize * gridSize) ~/ 2;

  late List<IconData> icons; // shuffled deck (length = gridSize * gridSize)
  late List<bool> cardsUp; // temporary face-up states
  late List<bool> matched; // permanently matched cards

  int? firstFlippedIndex; // index of the first flipped card in the current attempt
  bool allowFlip = true; // used to block input while waiting to flip back

  @override
  void initState() {
    super.initState();
    cardsUp = List.generate(gridSize * gridSize, (_) => false);
    _startNewGame();
  }

  void _startNewGame() {
    // getIcons(pairCount) should return pairCount*2 shuffled icons (e.g. 16 icons for 8 pairs)
    icons = DatIcons.getIcons(pairCount);

    // sanity check (only active in debug)
    assert(
      icons.length == gridSize * gridSize,
      'DatIcons.getIcons($pairCount) must return ${gridSize * gridSize} icons.',
    );

    cardsUp = List.generate(gridSize * gridSize, (_) => false);
    matched = List.generate(gridSize * gridSize, (_) => false);
    firstFlippedIndex = null;
    allowFlip = true;
  }

  void _onCardTap(int index) {
    // basic guards
    if (!allowFlip) return; // we're waiting (e.g. to flip back)
    if (cardsUp[index] || matched[index]) return; // already open or matched

    // flip the tapped card up
    setState(() {
      cardsUp[index] = true;
    });

    // if this is the first of the pair -> store it and wait for the second
    if (firstFlippedIndex == null) {
      firstFlippedIndex = index;
      return;
    }

    // otherwise this is the second card -> check match
    final int firstIndex = firstFlippedIndex!;
    final int secondIndex = index;

    // same icon? (IconData comparison is fine)
    if (icons[firstIndex] == icons[secondIndex]) {
      // it's a match: keep them open and mark as matched
      setState(() {
        matched[firstIndex] = true;
        matched[secondIndex] = true;
        firstFlippedIndex = null;
      });
      _checkForWin();
    } else {
      // not a match: block interactions, wait a bit so the player sees both, then flip back
      allowFlip = false;
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          cardsUp[firstIndex] = false;
          cardsUp[secondIndex] = false;
          firstFlippedIndex = null;
          allowFlip = true;
        });
      });
    }
  }

  void _checkForWin() {
    if (matched.every((m) => m)) {
      // All matched — show a dialog and offer to play again
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('You won! 🎉'),
            content: const Text('Great job! Do you want to play again?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _startNewGame();
                  });
                },
                child: const Text('Play again'),
              ),
            ],
          );
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
        // optional: you already had a refresh in the sample; we keep it here:
        extraActions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _startNewGame();
              });
            },
          ),
        ],
      ),
      drawer: WidDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: gridSize * gridSize,
          itemBuilder: (context, index) {
            return WidCard(
              isFaceUp: cardsUp[index] || matched[index],
              frontIcon: icons[index],
              onTap: () => _onCardTap(index),
            );
          },
        ),
      ),
    );
  }






}


