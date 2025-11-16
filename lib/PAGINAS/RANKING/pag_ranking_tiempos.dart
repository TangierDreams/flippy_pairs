//------------------------------------------------------------------------------
// PAGINA DONDE MOSTRAMOS EL RANKING POR TIEMPOS DE LA COMPETICION MUNDIAL FLIPPY.
//------------------------------------------------------------------------------

import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PAGINAS/RANKING/MODELOS/player_group.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fechas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_supabase.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flutter/material.dart';

class PagRankingTiempos extends StatefulWidget {
  const PagRankingTiempos({super.key});

  @override
  State<PagRankingTiempos> createState() => _PagRankingTiemposState();
}

class _PagRankingTiemposState extends State<PagRankingTiempos> {
  // Aquí almacenamos la lista completa de jugadores:
  late Future<List<Map<String, dynamic>>> listaRanking;

  // Mi id:

  String miId = SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: '');

  // Posición en la lista:

  int posicion = 0;

  //----------------------------------------------------------------------------
  // Buscamos la posición del usuario en la lista
  //----------------------------------------------------------------------------

  int _encontrarMiPosicion(List<Map<String, dynamic>> jugadores) {
    for (int i = 0; i < jugadores.length; i++) {
      if (jugadores[i]['id'] == miId) {
        return i + 1; // +1 porque las posiciones empiezan en 1
      }
    }
    return 0; // Si no se encuentra
  }

  @override
  void initState() {
    super.initState();
    SrvLogger.grabarLog('pag_ranking_tiempos', 'initState()', 'Entramos en la pagina de ranking de tiempos');
    listaRanking = SrvSupabase.obtenerTiemposFlippy();
  }

  @override
  void dispose() {
    SrvLogger.grabarLog('pag_ranking_tiempos', 'dispose()', 'Salimos de la pagina de ranking de tiempos');
    super.dispose();
  }

  //----------------------------------------------------------------------------
  // Creamos una lista con los distintos grupos de jugadores:
  // 10% - Top players
  // 10% - Best players
  // 70% - Normal players
  // 10% - Bad players
  //----------------------------------------------------------------------------
  List<PlayerGroup> _crearGruposDeJugadores(List<Map<String, dynamic>> pJugadores) {
    final gruposDeJugadores = <PlayerGroup>[];
    final totalPlayers = pJugadores.length;

    if (totalPlayers == 0) return gruposDeJugadores;

    // Calculamos el numero de jugadores de cada grupo:

    final topPlayersCount = (totalPlayers * 0.1).ceil(); // 10% - Top Players
    final goodPlayersCount = (totalPlayers * 0.1).ceil(); // 10% - Good Players
    final badPlayersCount = (totalPlayers * 0.1).ceil(); // 10% - Bad Players
    final normalPlayersCount =
        totalPlayers - topPlayersCount - goodPlayersCount - badPlayersCount; // 70% - Normal Players

    // Nos aseguramos de que los "normal players" no queden en negativo:

    final adjustedNormalPlayersCount = normalPlayersCount >= 0 ? normalPlayersCount : 0;
    final adjustedBadPlayersCount = normalPlayersCount >= 0
        ? badPlayersCount
        : totalPlayers - topPlayersCount - goodPlayersCount;

    //-------------------------
    // Top Players (first 10%)
    //-------------------------

    if (topPlayersCount > 0) {
      gruposDeJugadores.add(
        PlayerGroup(
          title: SrvTraducciones.get('primerost'),
          players: pJugadores.sublist(0, topPlayersCount),
          giphy: '🚀',
        ),
      );
    }

    //------------------------
    // Good Players (next 10%)
    //------------------------

    if (goodPlayersCount > 0 && topPlayersCount + goodPlayersCount <= totalPlayers) {
      gruposDeJugadores.add(
        PlayerGroup(
          title: SrvTraducciones.get('segundost'),
          players: pJugadores.sublist(topPlayersCount, topPlayersCount + goodPlayersCount),
          giphy: '🏎️💨',
        ),
      );
    }

    //---------------------------
    // Normal Players (next 70%)
    //---------------------------

    if (adjustedNormalPlayersCount > 0 &&
        topPlayersCount + goodPlayersCount + adjustedNormalPlayersCount <= totalPlayers) {
      gruposDeJugadores.add(
        PlayerGroup(
          title: SrvTraducciones.get('tercerost'),
          players: pJugadores.sublist(
            topPlayersCount + goodPlayersCount,
            topPlayersCount + goodPlayersCount + adjustedNormalPlayersCount,
          ),
          giphy: '🚴',
        ),
      );
    }

    //------------------------
    // Bad Players (last 10%)
    //------------------------

    if (adjustedBadPlayersCount > 0) {
      gruposDeJugadores.add(
        PlayerGroup(
          title: SrvTraducciones.get('cuartost'),
          players: pJugadores.sublist(totalPlayers - adjustedBadPlayersCount),
          giphy: '🛴',
        ),
      );
    }

    //----------------------------------------------------
    // Si hay muy pocos jugadores, montamos un solo grupo.
    //----------------------------------------------------

    if (gruposDeJugadores.isEmpty) {
      gruposDeJugadores.add(PlayerGroup(title: SrvTraducciones.get('todos'), players: pJugadores, giphy: '🚀'));
    }

    return gruposDeJugadores;
  }

  //----------------------------------------------------------------------------
  // Widget para mostrar el registro de un jugador
  //----------------------------------------------------------------------------

  Widget _mostrarJugador(Map<String, dynamic> player) {
    posicion += 1;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        //border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Columna de posición
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: player['id'] == miId
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: SrvColores.get(context, 'primero'), shape: BoxShape.circle),
                      child: Text(
                        posicion.toString(),
                        style: Textos.chewy(
                          context,
                          16,
                          SrvColores.get(context, 'textos'),
                          pColorSombra: SrvColores.get(context, 'fondo'),
                        ),
                      ),
                    )
                  : Text(
                      posicion.toString(),
                      style: Textos.chewy(
                        context,
                        16,
                        SrvColores.get(context, 'textos'),
                        pColorSombra: SrvColores.get(context, 'fondo'),
                      ),
                    ),
            ),
          ),

          // Columna de nombre y ubicación (ahora en dos líneas)
          Expanded(
            flex: 4, // Aumentamos el flex ya que ahora contendrá más información
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Línea 1: Nombre del jugador
                Text(
                  player['nombre']?.toString() ?? '',
                  style: player['id'] == miId
                      ? Textos.chewy(
                          context,
                          16,
                          SrvColores.get(context, 'primero'),
                          pColorSombra: SrvColores.get(context, 'fondo'),
                        )
                      : Textos.chewy(
                          context,
                          16,
                          SrvColores.get(context, 'textos'),
                          pColorSombra: SrvColores.get(context, 'fondo'),
                        ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                // Línea 2: Ciudad y bandera
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Country flag
                    Image.network(
                      'https://flagcdn.com/16x12/${player['pais']?.toLowerCase()}.png',
                      width: 16,
                      height: 12,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 16,
                          height: 12,
                          color: Colors.grey[300],
                          child: Icon(Icons.error_outline, size: 10, color: Colors.grey),
                        );
                      },
                    ),
                    SizedBox(width: 4), // Espacio reducido
                    // City name
                    Text(
                      player['ciudad']?.toString() ?? '',
                      style: player['id'] == miId
                          ? Textos.chewy(
                              context,
                              12,
                              SrvColores.get(context, 'primero'),
                              pColorSombra: SrvColores.get(context, 'fondo'),
                            )
                          : Textos.chewy(
                              context,
                              12,
                              SrvColores.get(context, 'textos'),
                              pColorSombra: SrvColores.get(context, 'fondo'),
                            ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Columna de tiempo récord
          Expanded(
            flex: 2,
            child: Text(
              SrvFechas.segundosAMinutosYSegundos(player['tiempo_record'] ?? 0),
              style: player['id'] == miId
                  ? Textos.chewy(
                      context,
                      16,
                      SrvColores.get(context, 'primero'),
                      pColorSombra: SrvColores.get(context, 'fondo'),
                    )
                  : Textos.chewy(
                      context,
                      16,
                      SrvColores.get(context, 'textos'),
                      pColorSombra: SrvColores.get(context, 'fondo'),
                    ),
              textAlign: TextAlign.center,
            ),
          ),

          // Columna de puntos
          Expanded(
            flex: 1,
            child: Text(
              player['puntos']?.toString() ?? '',
              style: player['id'] == miId
                  ? Textos.chewy(
                      context,
                      12,
                      SrvColores.get(context, 'primero'),
                      pColorSombra: SrvColores.get(context, 'fondo'),
                    )
                  : Textos.chewy(
                      context,
                      12,
                      SrvColores.get(context, 'textos'),
                      pColorSombra: SrvColores.get(context, 'fondo'),
                    ),
              textAlign: TextAlign.center,
            ),
          ),

          // Columna de partidas
          Expanded(
            flex: 1,
            child: Text(
              player['partidas']?.toString() ?? '',
              style: player['id'] == miId
                  ? Textos.chewy(
                      context,
                      12,
                      SrvColores.get(context, 'primero'),
                      pColorSombra: SrvColores.get(context, 'fondo'),
                    )
                  : Textos.chewy(
                      context,
                      12,
                      SrvColores.get(context, 'textos'),
                      pColorSombra: SrvColores.get(context, 'fondo'),
                    ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build a group section
  Widget _buildGroupSection(PlayerGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 10, thickness: 2, color: SrvColores.get(context, 'segundo'), indent: 8, endIndent: 8),
        // Group Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          color: SrvColores.get(context, 'fondo'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icono del Grupo:
              Text(
                group.giphy,
                style: Textos.luckiestGuy(
                  context,
                  32,
                  SrvColores.get(context, 'primero'),
                  pColorSombra: SrvColores.get(context, 'fondo'),
                ),
              ),

              // Texto Central
              Expanded(
                child: Text(
                  '${group.title} • ${group.players.length}',
                  textAlign: TextAlign.center,
                  style: Textos.luckiestGuy(
                    context,
                    18,
                    SrvColores.get(context, 'primero'),
                    pColorSombra: SrvColores.get(context, 'fondo'),
                  ),
                ),
              ),

              // Icono del grupo
              Text(
                group.giphy,
                style: Textos.luckiestGuy(
                  context,
                  32,
                  SrvColores.get(context, 'primero'),
                  pColorSombra: SrvColores.get(context, 'fondo'),
                ),
              ),
            ],
          ),
        ),

        //------------------------------------------------
        // Cabeceras de las columnas de cada grupo
        //------------------------------------------------
        Container(
          padding: EdgeInsets.all(8),
          color: SrvColores.get(context, 'fondo'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1, // Posición
                child: Text(
                  '📍',
                  style: Textos.chewy(
                    context,
                    18,
                    SrvColores.get(context, 'negro'),
                    pColorSombra: SrvColores.get(context, 'fondo'),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 4, // Jugador (ahora incluye nombre y ubicación)
                child: Text(
                  '👤',
                  style: Textos.chewy(
                    context,
                    18,
                    SrvColores.get(context, 'negro'),
                    pColorSombra: SrvColores.get(context, 'fondo'),
                  ),
                ),
              ),

              Expanded(
                flex: 2, // Tiempo
                child: Text(
                  '⌚',
                  style: Textos.chewy(
                    context,
                    18,
                    SrvColores.get(context, 'negro'),
                    pColorSombra: SrvColores.get(context, 'fondo'),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              Expanded(
                flex: 1, // Puntos
                child: Text(
                  '🏅',
                  style: Textos.chewy(
                    context,
                    18,
                    SrvColores.get(context, 'negro'),
                    pColorSombra: SrvColores.get(context, 'fondo'),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1, // Partidas
                child: Text(
                  '🕹️',
                  style: Textos.chewy(
                    context,
                    18,
                    SrvColores.get(context, 'negro'),
                    pColorSombra: SrvColores.get(context, 'fondo'),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

        Divider(height: 10, thickness: 2, color: SrvColores.get(context, 'segundo'), indent: 8, endIndent: 8),

        //-----------------------------------------
        // Mostramos los jugadores del grupo actual
        //-----------------------------------------
        ...group.players.map((player) => _mostrarJugador(player)),
        SizedBox(height: 16), // Space between sections
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    posicion = 0;
    return Scaffold(
      backgroundColor: SrvColores.get(context, 'fondo'),
      //Toolbar:
      appBar: WidToolbar(showMenuButton: false, showBackButton: true, subtitle: SrvTraducciones.get('subtitulo_app')),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: listaRanking,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(SrvTraducciones.get('sin_datos')));
          }

          final allPlayers = snapshot.data!;
          final groups = _crearGruposDeJugadores(allPlayers);

          // Encontrar mi posición
          final miPosicion = _encontrarMiPosicion(allPlayers);

          return Column(
            children: [
              // Mensaje de posición del jugador - SIEMPRE VISIBLE
              //if (miPosicion > 0)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                color: SrvColores.get(context, 'fondo'),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Time ",
                            style: Textos.luckiestGuy(
                              context,
                              24,
                              SrvColores.get(context, 'segundo'),
                              pColorSombra: SrvColores.get(context, 'fondo'),
                            ), // Tamaño y color diferente
                          ),
                          TextSpan(
                            text: "Flippy Competition ${InfoNiveles.nivel[EstadoDelJuego.nivel]['titulo']}",
                            style: Textos.luckiestGuy(
                              context,
                              22,
                              SrvColores.get(context, 'primero'),
                              pColorSombra: SrvColores.get(context, 'fondo'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Text(
                    //   "Time Flippy Competition ${InfoNiveles.nivel[EstadoDelJuego.nivel]['titulo']}",
                    //   style: Textos.luckiestGuy(22, SrvColores.get(context, 'primero'), pColorSombra: SrvColores.get(context, 'fondo')),
                    //   textAlign: TextAlign.center,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.place, color: SrvColores.get(context, 'cuarto'), size: 20),
                        SizedBox(width: 8),
                        Text(
                          miPosicion > 0
                              ? '${SrvTraducciones.get('estas_en_posicion')} $miPosicion'
                              : SrvTraducciones.get('no_has_jugado'),
                          style: Textos.chewy(
                            context,
                            18,
                            SrvColores.get(context, 'primero'),
                            pColorSombra: SrvColores.get(context, 'fondo'),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Lista de grupos
              Expanded(child: ListView(children: groups.map((group) => _buildGroupSection(group)).toList())),
            ],
          );
        },
      ),
    );
  }
}
