import 'package:flippy_pairs/SHARED/SERVICES/srv_sounds.dart';
import 'package:flippy_pairs/SHARED/UTILS/constants.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_toolbar.dart';

// Variables globales:

int rowsSelected = 3;
int colsSelected = 2;

class PagHome extends StatefulWidget {
  const PagHome({super.key});

  @override
  State<PagHome> createState() => _PagHomeState();
}

class _PagHomeState extends State<PagHome> {
  // NEW: we keep track of the selected button index

  int selectedIndex = 0; // by default, first level selected

  // NEW: list of levels to avoid repeating code

  final levels = const [
    {"title": "3x2", "rows": 3, "cols": 2},
    {"title": "4x3", "rows": 4, "cols": 3},
    {"title": "5x4", "rows": 5, "cols": 4},
    {"title": "6x5", "rows": 6, "cols": 5},
    {"title": "8x7", "rows": 8, "cols": 7},
    {"title": "9x8", "rows": 9, "cols": 8},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Toolbar:
      appBar: WidToolbar(
        showMenuButton: false,
        showBackButton: false,
        //showCloseButton: false,
        subtitle: "Harden Your Mind Once and for All!",
      ),

      //drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Difficulty', textAlign: TextAlign.center, style: AppTexts.textStyleOrange30),

            const SizedBox(height: 15),

            // Generate the buttons dynamically in 2 rows
            for (int row = 0; row < 2; row++) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (col) {
                  final index = row * 3 + col; // compute global index
                  final level = levels[index];
                  return LevelButton(
                    pTitle: level["title"] as String,
                    pRows: level["rows"] as int,
                    pCols: level["cols"] as int,
                    selected: selectedIndex == index, // highlight if selected
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        rowsSelected = level["rows"] as int;
                        colsSelected = level["cols"] as int;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],

            PlayButton(),
          ],
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------
// Botón Play
//------------------------------------------------------------------------------
class PlayButton extends StatelessWidget {
  const PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        SrvSounds().emitPlaySound();

        // Esperamos un poco para que se perciba el sonido
        await Future.delayed(const Duration(milliseconds: 300));

        if (context.mounted) {
          Navigator.of(context).pushNamed('/game', arguments: {'pRows': rowsSelected, 'pCols': colsSelected});
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.contrast,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
      ),

      child: Text('Start Playing!', style: AppTexts.textStyleOrange28, textAlign: TextAlign.center),
    );
  }
}

//------------------------------------------------------------------------------
// Boton de nivel.
//------------------------------------------------------------------------------
class LevelButton extends StatelessWidget {
  final String pTitle;
  final int pRows;
  final int pCols;
  final bool selected;
  final VoidCallback onTap;

  const LevelButton({
    super.key,
    required this.pTitle,
    required this.pRows,
    required this.pCols,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: selected ? 1.2 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      child: ElevatedButton(
        onPressed: () async {
          SrvSounds().emitLevelSound();
          onTap();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          backgroundColor: selected ? Colors.orange : AppColors.primary,
          foregroundColor: AppColors.contrast,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: selected ? 15 : 10,
        ),
        child: Text(pTitle, style: AppTexts.textStyleYellow30, textAlign: TextAlign.center),
      ),
    );
  }
}
