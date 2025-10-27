import 'package:flippy_pairs/PAGINAS/CONFIGURACION/pag_configuracion.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/pag_juego.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/srv_juego.dart';
import 'package:flippy_pairs/PAGINAS/LOGS/pag_logs.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_dispositivo.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_idiomas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_imagenes.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PAGINAS/_HOME/pag_home.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(url: DatosGenerales.supabaseUrl, anonKey: DatosGenerales.supabaseKey);
  } catch (e) {
    SrvLogger.grabarLog('Main', 'main()', 'Error Supabase: $e');
  }

  try {
    await SrvDiskette.inicializar();
  } catch (e) {
    SrvLogger.grabarLog('Main', 'main()', 'Error Diskette: $e');
  }

  try {
    await SrvImagenes.inicializar();
  } catch (e) {
    SrvLogger.grabarLog('Main', 'main()', 'Error Imagenes: $e');
  }

  try {
    await SrvIdiomas.inicializar();
  } catch (e) {
    SrvLogger.grabarLog('Main', 'main()', 'Error Idioma: $e');
  }

  try {
    await SrvSonidos.inicializar();
  } catch (e) {
    SrvLogger.grabarLog('Main', 'main()', 'Error Sonidos: $e');
  }
  try {
    await SrvDispositivo.obtenerId();
    SrvLogger.grabarLog(
      'Main',
      'main()',
      'El id del dispositivo es: ${SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: '?')}',
    );
  } catch (e) {
    SrvLogger.grabarLog('Main', 'main()', 'Error Dispositivo: $e');
  }
  try {
    await SrvTracking.obtenerDatos();
  } catch (e) {
    SrvLogger.grabarLog('Main', 'main()', 'Error Tracking: $e');
  }

  SrvLogger.grabarLog('Main', 'main()', 'App iniciada');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        SrvLogger.grabarLog('Main', '_MyAppState', 'App en primer plano');
        if (InfoJuego.musicaActiva) {
          SrvSonidos.iniciarMusicaFondo();
        }
        SrvJuego.reanudarCronometro();
        break;
      case AppLifecycleState.inactive:
        SrvSonidos.detenerMusicaFondo();
        SrvJuego.pausarCronometro();
        SrvLogger.grabarLog('Main', '_MyAppState', 'App pasa a inactiva');
        break;
      case AppLifecycleState.paused:
        SrvSonidos.detenerMusicaFondo();
        SrvJuego.pausarCronometro();
        SrvLogger.grabarLog('Main', '_MyAppState', 'La app pasa a segundo plano');
        break;
      case AppLifecycleState.detached:
        SrvSonidos.liberar();
        SrvLogger.grabarLog('Main', '_MyAppState', 'App cerrada');
        break;
      default:
        SrvLogger.grabarLog('Main', '_MyAppState', 'Otro estado del ciclo de vida...');
    }
  }

  @override
  Widget build(BuildContext context) {
    String rutaInicial = '/';
    String nomDispositivo = SrvDiskette.leerValor(DisketteKey.deviceName, defaultValue: '');
    if (nomDispositivo == '') {
      rutaInicial = '/config';
    }

    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: DatosGenerales.nombreApp,
      initialRoute: rutaInicial,
      routes: {
        '/': (context) => PagHome(),
        '/game': (context) => PagJuego(),
        '/config': (context) => PagConfiguracion(),
        '/logs': (context) => PagLogs(),
      },
    );
  }
}
