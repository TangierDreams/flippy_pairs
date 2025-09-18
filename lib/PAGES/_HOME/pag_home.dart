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

  // Lista donde mantenemos si la carta esta boca arriba o boca abajo:
  
  final List<bool> cardStates = List.generate(gridSize * gridSize, (_) => false);

  // Example: icons for cards (you’ll later duplicate & shuffle them for real pairs)
  final List<IconData> icons = [
    Icons.star, Icons.favorite, Icons.ac_unit, Icons.pets,
    Icons.cake, Icons.flight, Icons.music_note, Icons.sports_soccer,
    Icons.star, Icons.favorite, Icons.ac_unit, Icons.pets,
    Icons.cake, Icons.flight, Icons.music_note, Icons.sports_soccer,
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      //Toolbar:
      
      appBar: WidToolbar(
        showMenuButton: true,
        showBackButton: false,
        showCloseButton: false,
      ),

      // Menú Lateral:

      drawer: WidDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize, // 4 cards per row
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: gridSize * gridSize, // 16 cards total
          itemBuilder: (context, index) {
            return GestureDetector(
              // onTap: () {
              //   setState(() {
              //     cardStates[index] = !cardStates[index]; 
              //   });
              // },
              child: WidCard(
                isFaceUp: cardStates[index],
                frontIcon: icons[index],
                onTap: () {
                  setState(() {
                    cardStates[index] = !cardStates[index];
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}


