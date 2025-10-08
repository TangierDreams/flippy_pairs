import 'package:flippy_pairs/PAGINAS/CONFIGURACION/pag_configuracion.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/pag_juego.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_dispositivo.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PAGINAS/_HOME/pag_home.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SrvDiskette.inicializar();
  await SrvSonidos.inicializar();
  await SrvDispositivo.obtenerId();
  await SrvTracking.obtenerDatos();
  await Supabase.initialize(url: DatosGenerales.supabaseUrl, anonKey: DatosGenerales.supabaseKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: DatosGenerales.nombreApp,

      //---------------------------------
      // ROUTING A LAS DISTINTAS PAGINAS:
      //---------------------------------
      initialRoute: '/',
      routes: {
        //Home:
        '/': (context) => const PagHome(),
        //Juego:
        '/game': (context) => const PagJuego(),
        //Configuracion:
        '/config': (context) => const PagConfiguracion(),
      },
    );
  }
}
