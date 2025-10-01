import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_imagenes.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_contador.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_juego_acabado.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_carta.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flippy_pairs/PAGINAS/JUEGO/WIDGETS/wid_temporizador.dart';

// ============================================================================
// VARIABLES GLOBALES DEL JUEGO
// ============================================================================

// Configuración del tablero
late int _filas;
late int _columnas;
late int _cartasTotales;
late int _parejasTotales;

// Las cartas y su estado
late List<String> _imagenes; // Los iconos de cada carta
late List<bool> _cartasGiradas; // true = carta boca arriba
late List<bool> _cartasEmparejadas; // true = ya hizo match

// Control del turno actual
int? _primeraCarta; // índice de la primera carta volteada
bool _puedoGirarLaCarta = true; // false = esperando a que se oculten las cartas

// Puntuaciones
int _puntosTotales = 0; // Puntos acumulados (se guardan en disco)
int _puntosPartida = 0; // Puntos solo de esta partida
int _parejasAcertadas = 0;
int _parejasFalladas = 0;

// Para el efecto visual de flash
Set<int> _cartasDestello = {};

// ============================================================================
// FUNCIONES DE INICIALIZACIÓN
// ============================================================================

void inicializarJuego(int pFilas, int pColumnas) async {
  _filas = pFilas;
  _columnas = pColumnas;
  _cartasTotales = _filas * _columnas;
  _parejasTotales = _cartasTotales ~/ 2;

  // Conseguir los iconos aleatorios
  _imagenes = SrvImagenes.obtenerImagenes(_parejasTotales);

  // Resetear todos los estados
  _cartasGiradas = List.filled(_cartasTotales, false);
  _cartasEmparejadas = List.filled(_cartasTotales, false);

  _primeraCarta = null;
  _puedoGirarLaCarta = true;

  _parejasAcertadas = 0;
  _parejasFalladas = 0;
  _puntosPartida = 0;

  _cartasDestello = {};

  // Cargar puntos guardados del disco
  _puntosTotales = await Diskette.leerValor("puntuacion", defaultValue: 0);
}

void resetearJuego() {
  inicializarJuego(_filas, _columnas);
}

// ============================================================================
// FUNCIONES DE LÓGICA PURA
// ============================================================================

// Comprobamos si 2 cartas son iguales:

bool esPareja(int carta1, int carta2) {
  return _imagenes[carta1] == _imagenes[carta2];
}

// Si todas las cartas están emparejadas, se acabó el juego:

bool juegoTerminado() {
  for (bool emparejada in _cartasEmparejadas) {
    if (!emparejada) return false;
  }
  return true;
}

// Sumamos puntos:

void sumarPuntos() {
  _puntosTotales += InfoJuego.niveles[InfoJuego.nivelSeleccionado]["puntosMas"] as int;
  _puntosPartida += InfoJuego.niveles[InfoJuego.nivelSeleccionado]["puntosMas"] as int;
}

// Restamos puntos:

void restarPuntos() {
  _puntosTotales -= InfoJuego.niveles[InfoJuego.nivelSeleccionado]["puntosMenos"] as int;
  _puntosPartida -= InfoJuego.niveles[InfoJuego.nivelSeleccionado]["puntosMenos"] as int;
}

// ============================================================================
// FUNCIÓN PRINCIPAL: MANEJAR EL TOQUE EN UNA CARTA
// ============================================================================

Future<void> manejarToqueCarta(int index, Function setState) async {
  // 1. VERIFICACIONES BÁSICAS

  // Si no puedo voltear, ignoro el toque
  if (!_puedoGirarLaCarta) return;

  // Si la carta ya está volteada o emparejada, ignoro
  if (_cartasGiradas[index] || _cartasEmparejadas[index]) return;

  // 2. VOLTEAR LA CARTA

  setState(() {
    _cartasGiradas[index] = true;
  });

  // 3. ¿ES LA PRIMERA O LA SEGUNDA CARTA?

  // Si es la primera carta del turno
  if (_primeraCarta == null) {
    _primeraCarta = index;
    return; // Esperamos a que volteen la segunda
  }

  // Si llegamos aquí, es la segunda carta
  int indicePrimera = _primeraCarta!;
  int indiceSegunda = index;

  // 4. COMPROBAR SI HACEN PAREJA

  if (esPareja(indicePrimera, indiceSegunda)) {
    // ¡MATCH! ✓

    setState(() {
      _cartasEmparejadas[indicePrimera] = true;
      _cartasEmparejadas[indiceSegunda] = true;
      _primeraCarta = null;
    });

    _parejasAcertadas++;
    sumarPuntos();

    // Efecto visual de parpadeo
    setState(() {
      _cartasDestello.add(indicePrimera);
      _cartasDestello.add(indiceSegunda);
    });

    Sonidos.level();

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _cartasDestello.clear();
    });

    // Verificar si hemos terminado el juego
    if (juegoTerminado()) {
      Diskette.guardarValor("puntuacion", _puntosTotales);
    }
  } else {
    // NO HACEN MATCH ✗

    _puedoGirarLaCarta = false; // Bloqueamos más toques
    _parejasFalladas++;
    restarPuntos();

    // Esperamos para que el jugador las vea
    await Future.delayed(const Duration(milliseconds: 800));

    Sonidos.goback();

    // Las volvemos a ocultar
    setState(() {
      _cartasGiradas[indicePrimera] = false;
      _cartasGiradas[indiceSegunda] = false;
      _primeraCarta = null;
      _puedoGirarLaCarta = true;
    });
  }
}

// ============================================================================
// WIDGET DE LA PÁGINA
// ============================================================================

class PagJuego extends StatefulWidget {
  const PagJuego({super.key});

  @override
  State<PagJuego> createState() => _PagJuegoState();
}

class _PagJuegoState extends State<PagJuego> {
  bool _juegoInicializado = false;
  final GlobalKey<WidTemporizadorState> _timerKey = GlobalKey<WidTemporizadorState>();

  @override
  void initState() {
    super.initState();
    _inicializarPantalla();
  }

  void _inicializarPantalla() async {
    await Future.microtask(() {});
    if (!mounted) return;

    // Obtener argumentos de navegación
    //final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //int rows = args['pRows'];
    //int cols = args['pCols'];

    // Inicializar el juego con las variables globales

    inicializarJuego(InfoJuego.filasSeleccionadas, InfoJuego.columnasSeleccionadas);

    setState(() {
      _juegoInicializado = true;
    });

    // Iniciar el timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _timerKey.currentState?.start();
      }
    });
  }

  @override
  void dispose() {
    _timerKey.currentState?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_juegoInicializado) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: WidToolbar(showMenuButton: false, showBackButton: true, subtitle: "Harden Your Mind Once and for All!"),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Contadores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WidContador(pTexto: "Points: ", pContador: _puntosTotales, pModo: 1),
              WidContador(pTexto: "Match: ", pContador: _parejasAcertadas, pModo: 1),
              WidContador(pTexto: "Fail: ", pContador: _parejasFalladas, pModo: 2),
              WidTemporizador(key: _timerKey, pModo: 1),
            ],
          ),

          // Grid de cartas
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _columnas,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _cartasTotales,
                itemBuilder: (context, index) {
                  return WidCarta(
                    pEstaBocaArriba: _cartasGiradas[index] || _cartasEmparejadas[index],
                    pImagenCarta: _imagenes[index],
                    pDestello: _cartasDestello.contains(index),
                    pAlPresionar: () async {
                      Sonidos.flip();

                      await manejarToqueCarta(index, setState);

                      // Si el juego ha terminado
                      if (juegoTerminado()) {
                        _timerKey.currentState?.stop();
                        await Future.delayed(const Duration(milliseconds: 500));

                        if (context.mounted) {
                          widJuegoAcabado(
                            context,
                            _puntosPartida,
                            _puntosTotales,
                            _timerKey.currentState!.getTiempoFormateado,
                            pAlJugarOtraVez: () {
                              setState(() {
                                resetearJuego();
                                _timerKey.currentState?.reset();
                                _timerKey.currentState?.start();
                              });
                            },
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
