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
  try {
    await SrvDiskette.inicializar();
    debugPrint('Diskette inicializado');
  } catch (e, st) {
    debugPrint('Error Diskette: $e\n$st');
  }
  try {
    await SrvSonidos.inicializar();
    debugPrint('Sonidos inicializados');
  } catch (e, st) {
    debugPrint('Error Sonidos: $e\n$st');
  }
  try {
    await SrvDispositivo.obtenerId();
    debugPrint('ID Dispositivo obtenido');
  } catch (e, st) {
    debugPrint('Error Dispositivo: $e\n$st');
  }
  try {
    await SrvTracking.obtenerDatos();
    debugPrint('Datos de tracking obtenidos');
  } catch (e, st) {
    debugPrint('Error Tracking: $e\n$st');
  }
  try {
    await Supabase.initialize(url: DatosGenerales.supabaseUrl, anonKey: DatosGenerales.supabaseKey);
    debugPrint('Supabase inicializado');
  } catch (e, st) {
    debugPrint('Error Supabase: $e\n$st');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Si no tenemos nombre de dispositivo empezamos por la pagina de configuración:

    String rutaInicial = "/";
    String nomDispositivo = SrvDiskette.leerValor(DisketteKey.deviceName, defaultValue: '');
    debugPrint('Dispositivo: $nomDispositivo');
    if (nomDispositivo == '') {
      rutaInicial = "/config";
    }

    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: DatosGenerales.nombreApp,

      //---------------------------------
      // ROUTING A LAS DISTINTAS PAGINAS:
      //---------------------------------
      initialRoute: rutaInicial,
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
