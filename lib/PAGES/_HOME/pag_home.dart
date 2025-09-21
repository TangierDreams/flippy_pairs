import 'package:flippy_pairs/UTILS/constants.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_toolbar.dart';

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
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Juego 6x5, 8x7, 9x8.:
            GridButton(pTitle: "Jugar con Cuadrícula de 3x2", pRows: 3, pCols: 2),

            const SizedBox(height: 20),

            GridButton(pTitle: "Jugar con Cuadrícula de 4x3", pRows: 4, pCols: 3),

            const SizedBox(height: 20),

            GridButton(pTitle: "Jugar con Cuadrícula de 5x4", pRows: 5, pCols: 4),

            const SizedBox(height: 20),

            GridButton(pTitle: "Jugar con Cuadrícula de 6x5", pRows: 6, pCols: 5),

            const SizedBox(height: 20),

            GridButton(pTitle: "Jugar con Cuadrícula de 8x7", pRows: 8, pCols: 7),

            const SizedBox(height: 20),

            GridButton(pTitle: "Jugar con Cuadrícula de 9x8", pRows: 9, pCols: 8),

            const SizedBox(height: 20),
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

  const GridButton({super.key, required this.pTitle, required this.pRows, required this.pCols});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(
          context,
        ).pushNamed('/game', arguments: {'pRows': pRows, 'pCols': pCols});
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.contrast,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
      ),
      child: Text(
        pTitle,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
