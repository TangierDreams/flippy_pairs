import 'package:flippy_pairs/PAGES/GAME/pag_game.dart';
import 'package:flippy_pairs/SHARED/SERVICES/srv_device_id.dart';
import 'package:flippy_pairs/SHARED/SERVICES/srv_diskette.dart';
import 'package:flippy_pairs/SHARED/SERVICES/srv_sounds.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PAGES/_HOME/pag_home.dart';
import 'package:flippy_pairs/SHARED/UTILS/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SrvDiskette.init();
  await SrvSounds().init();
  await SrvDeviceId.getDeviceId();
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
      routes: {'/': (context) => const PagHome(), '/game': (context) => const PagGame()},
    );
  }
}
