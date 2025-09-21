import 'package:flippy_pairs/PAGES/GAME/pag_game.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PAGES/_HOME/pag_home.dart';
import 'package:flippy_pairs/UTILS/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
