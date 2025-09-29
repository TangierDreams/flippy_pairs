import 'package:flippy_pairs/SHARED/SERVICES/srv_sounds.dart';
import 'package:flippy_pairs/SHARED/SERVICES/srv_diskette.dart';
import 'package:flippy_pairs/SHARED/DATA/dat_icons.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_counter.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_game_over.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_card.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_toolbar.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_timer.dart';

// ============================================================================
// VARIABLES GLOBALES DEL JUEGO
// ============================================================================

// Configuración del tablero
late int _rows;
late int _cols;
late int _totalCards;
late int _totalPairs;

// Las cartas y su estado
late List<IconData> _icons; // Los iconos de cada carta
late List<bool> _cartasVolteadas; // true = carta boca arriba
late List<bool> _cartasEmparejadas; // true = ya hizo match

// Control del turno actual
int? _primeraCarta; // índice de la primera carta volteada
bool _puedoVoltearCarta = true; // false = esperando a que se oculten las cartas

// Puntuaciones
int _puntosTotal = 0; // Puntos acumulados (se guardan en disco)
int _puntosPartida = 0; // Puntos solo de esta partida
int _parejasAcertadas = 0;
int _parejasFalladas = 0;

// Para el efecto visual de flash
Set<int> _cartasParpadeando = {};

// ============================================================================
// FUNCIONES DE INICIALIZACIÓN
// ============================================================================

void inicializarJuego(int rows, int cols) {
  _rows = rows;
  _cols = cols;
  _totalCards = rows * cols;
  _totalPairs = _totalCards ~/ 2;

  // Conseguir los iconos aleatorios
  _icons = DatIcons.getIcons(_totalPairs);

  // Resetear todos los estados
  _cartasVolteadas = List.filled(_totalCards, false);
  _cartasEmparejadas = List.filled(_totalCards, false);

  _primeraCarta = null;
  _puedoVoltearCarta = true;

  _parejasAcertadas = 0;
  _parejasFalladas = 0;
  _puntosPartida = 0;

  _cartasParpadeando = {};

  // Cargar puntos guardados del disco
  _puntosTotal = SrvDiskette.get("puntuacion", defaultValue: 0) as int;
}

void resetearJuego() {
  inicializarJuego(_rows, _cols);
}

// ============================================================================
// FUNCIONES DE LÓGICA PURA
// ============================================================================

bool esPareja(int carta1, int carta2) {
  return _icons[carta1] == _icons[carta2];
}

bool juegoTerminado() {
  // Si todas las cartas están emparejadas, hemos ganado
  for (bool emparejada in _cartasEmparejadas) {
    if (!emparejada) return false;
  }
  return true;
}

void sumarPuntos(int puntos) {
  _puntosTotal += puntos;
  _puntosPartida += puntos;
}

void restarPuntos(int puntos) {
  _puntosTotal -= puntos;
  _puntosPartida -= puntos;
}

void guardarPuntuacion() {
  SrvDiskette.set("puntuacion", value: _puntosTotal);
}

// ============================================================================
// FUNCIÓN PRINCIPAL: MANEJAR EL TOQUE EN UNA CARTA
// ============================================================================

Future<void> manejarToqueCarta(int index, Function setState) async {
  // 1. VERIFICACIONES BÁSICAS

  // Si no puedo voltear, ignoro el toque
  if (!_puedoVoltearCarta) return;

  // Si la carta ya está volteada o emparejada, ignoro
  if (_cartasVolteadas[index] || _cartasEmparejadas[index]) return;

  // 2. VOLTEAR LA CARTA

  setState(() {
    _cartasVolteadas[index] = true;
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
    sumarPuntos(10);

    // Efecto visual de parpadeo
    setState(() {
      _cartasParpadeando.add(indicePrimera);
      _cartasParpadeando.add(indiceSegunda);
    });

    SrvSounds().emitLevelSound();

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _cartasParpadeando.clear();
    });

    // Verificar si hemos terminado el juego
    if (juegoTerminado()) {
      guardarPuntuacion();
    }
  } else {
    // NO HACEN MATCH ✗

    _puedoVoltearCarta = false; // Bloqueamos más toques
    _parejasFalladas++;
    restarPuntos(1);

    // Esperamos para que el jugador las vea
    await Future.delayed(const Duration(milliseconds: 800));

    SrvSounds().emitGobackSound();

    // Las volvemos a ocultar
    setState(() {
      _cartasVolteadas[indicePrimera] = false;
      _cartasVolteadas[indiceSegunda] = false;
      _primeraCarta = null;
      _puedoVoltearCarta = true;
    });
  }
}

// ============================================================================
// WIDGET DE LA PÁGINA
// ============================================================================

class PagGame extends StatefulWidget {
  const PagGame({super.key});

  @override
  State<PagGame> createState() => _PagGameState();
}

class _PagGameState extends State<PagGame> {
  bool _juegoInicializado = false;
  final GlobalKey<WidTimerState> _timerKey = GlobalKey<WidTimerState>();

  @override
  void initState() {
    super.initState();
    _inicializarPantalla();
  }

  void _inicializarPantalla() async {
    await Future.microtask(() {});
    if (!mounted) return;

    // Obtener argumentos de navegación
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    int rows = args['pRows'];
    int cols = args['pCols'];

    // Inicializar el juego con las variables globales
    inicializarJuego(rows, cols);

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
              WidCounter(text: "Points: ", counter: _puntosTotal, mode: 1),
              WidCounter(text: "Match: ", counter: _parejasAcertadas, mode: 1),
              WidCounter(text: "Fail: ", counter: _parejasFalladas, mode: 2),
              WidTimer(key: _timerKey, mode: 1),
            ],
          ),

          // Grid de cartas
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _cols,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _totalCards,
                itemBuilder: (context, index) {
                  return WidCard(
                    isFaceUp: _cartasVolteadas[index] || _cartasEmparejadas[index],
                    frontIcon: _icons[index],
                    isFlashing: _cartasParpadeando.contains(index),
                    onTap: () async {
                      SrvSounds().emitFlipSound();

                      await manejarToqueCarta(index, setState);

                      // Si el juego ha terminado
                      if (juegoTerminado()) {
                        _timerKey.currentState?.stop();
                        await Future.delayed(const Duration(milliseconds: 500));

                        if (context.mounted) {
                          widGameOver(
                            context,
                            _puntosPartida,
                            _puntosTotal,
                            _timerKey.currentState!.formattedTime,
                            onPlayAgain: () {
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
