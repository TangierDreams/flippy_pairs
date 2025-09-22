import 'package:flippy_pairs/SHARED/UTILS/constants.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_toolbar.dart';
import 'package:google_fonts/google_fonts.dart';

int rowsSelected = 3;
int colsSelected = 2;

class PagHome extends StatelessWidget {
  const PagHome({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //Toolbar:
      appBar: WidToolbar(
        showMenuButton: false,
        showBackButton: false,
        showCloseButton: false,
        subtitle: "Harden Your Mind Once and for All!",
      ),

      // Menú Lateral:

      //drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Difficulty',
              textAlign: TextAlign.center,
              style: GoogleFonts.chewy(
                textStyle: const TextStyle(
                  fontSize: 30,
                  height: 0.7,
                  color: Colors.orange,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black54,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GridButton(pTitle: "3x2", pRows: 3, pCols: 2),
                GridButton(pTitle: "4x3", pRows: 4, pCols: 3),
                GridButton(pTitle: "5x4", pRows: 5, pCols: 4),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GridButton(pTitle: "6x5", pRows: 6, pCols: 5),
                GridButton(pTitle: "8x7", pRows: 8, pCols: 7),
                GridButton(pTitle: "9x8", pRows: 9, pCols: 8),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed('/game', arguments: {'pRows': rowsSelected, 'pCols': colsSelected});
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.contrast,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 10,
              ),

              child: Text(
                'Start Playing!',
                style: GoogleFonts.luckiestGuy(
                  textStyle: const TextStyle(
                    fontSize: 28,
                    //height: 0.9,
                    color: Colors.orange,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black87,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridButton extends StatelessWidget {
  final String pTitle;
  final int pRows;
  final int pCols;

  const GridButton({
    super.key,
    required this.pTitle,
    required this.pRows,
    required this.pCols,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
            rowsSelected = pRows;
            colsSelected = pCols;
        },      
        style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.contrast,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
      ),
      child: Text(
        pTitle,
        style: GoogleFonts.chewy(
          textStyle: const TextStyle(
            fontSize: 30,
            height: 0.7,
            color: Colors.yellow,
            shadows: [
              Shadow(
                blurRadius: 4,
                color: Colors.black54,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
