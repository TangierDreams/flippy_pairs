import 'package:flippy_pairs/PAGINAS/JUEGO/pag_juego.dart';
import 'package:flippy_pairs/SHARED/SERVICIOS/srv_id_dispositivo.dart';
import 'package:flippy_pairs/SHARED/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/SHARED/SERVICIOS/srv_sonidos.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PAGINAS/_HOME/pag_home.dart';
import 'package:flippy_pairs/SHARED/SERVICIOS/srv_globales.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await disketteInicializar();
  await inicializarSonidos();
  await obtenerIdDispositivo();
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
      routes: {'/': (context) => const PagHome(), '/game': (context) => const PagJuego()},
    );
  }
}
