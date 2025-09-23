import 'package:audioplayers/audioplayers.dart';
import 'package:flippy_pairs/PAGES/GAME/pag_game.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PAGES/_HOME/pag_home.dart';
import 'package:flippy_pairs/SHARED/UTILS/constants.dart';

final AudioPlayer clickPlayer = AudioPlayer();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Preload the sound once
  await clickPlayer.setSource(AssetSource('sounds/play.mp3'));  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: AppGeneral.title,

      // ROUTING A LAS DISTINTAS PAGINAS:
      initialRoute: '/',
      routes: {
        '/': (context) => const PagHome(),
        '/game': (context) => const PagGame(),
      },
    );
  }
}
