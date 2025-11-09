//------------------------------------------------------------------------------
// PAGINA DONDE MOSTRAMOS EL RANKING DE LA COMPETICION MUNDIAL FLIPPY.
//------------------------------------------------------------------------------

import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PAGINAS/RANKING/MODELOS/player_group.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fechas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_supabase.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flutter/material.dart';

class PagRanking extends StatefulWidget {
  const PagRanking({super.key});

  @override
  State<PagRanking> createState() => _PagRankingState();
}

class _PagRankingState extends State<PagRanking> {
  // Aquí almacenamos la lista completa de jugadores:
  late Future<List<Map<String, dynamic>>> listaRanking;

  @override
  void initState() {
    super.initState();
    SrvLogger.grabarLog('pag_ranking', 'initState()', 'Entramos en la pagina de ranking');
    listaRanking = SrvSupabase.obtenerTablaFlippy();
  }

  @override
  void dispose() {
    SrvLogger.grabarLog('pag_ranking', 'dispose()', 'Salimos de la pagina de ranking');
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
          title: SrvTraducciones.get('primeros'),
          players: pJugadores.sublist(0, topPlayersCount),
          giphy: '🏆',
        ),
      );
    }

    //------------------------
    // Good Players (next 10%)
    //------------------------

    if (goodPlayersCount > 0 && topPlayersCount + goodPlayersCount <= totalPlayers) {
      gruposDeJugadores.add(
        PlayerGroup(
          title: SrvTraducciones.get('segundos'),
          players: pJugadores.sublist(topPlayersCount, topPlayersCount + goodPlayersCount),
          giphy: '✨',
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
          title: SrvTraducciones.get('terceros'),
          players: pJugadores.sublist(
            topPlayersCount + goodPlayersCount,
            topPlayersCount + goodPlayersCount + adjustedNormalPlayersCount,
          ),
          giphy: '🚶',
        ),
      );
    }

    //------------------------
    // Bad Players (last 10%)
    //------------------------

    if (adjustedBadPlayersCount > 0) {
      gruposDeJugadores.add(
        PlayerGroup(
          title: SrvTraducciones.get('cuartos'),
          players: pJugadores.sublist(totalPlayers - adjustedBadPlayersCount),
          giphy: '😈',
        ),
      );
    }

    //----------------------------------------------------
    // Si hay muy pocos jugadores, montamos un solo grupo.
    //----------------------------------------------------

    if (gruposDeJugadores.isEmpty) {
      gruposDeJugadores.add(PlayerGroup(title: SrvTraducciones.get('todos'), players: pJugadores, giphy: '🏆'));
    }

    return gruposDeJugadores;
  }

  //----------------------------------------------------------------------------
  // Widget para mostrar el registro de un jugador
  //----------------------------------------------------------------------------

  Widget _mostrarJugador(Map<String, dynamic> player) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              player['nombre']?.toString() ?? '',
              style: Textos.chewy(12, Colores.negro, pColorSombra: Colores.blanco),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
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
                SizedBox(width: 8), // Add some spacing
                // City name
                Text(player['ciudad'], style: Textos.chewy(12, Colores.negro, pColorSombra: Colores.blanco)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              player['puntos']?.toString() ?? '',
              style: Textos.chewy(16, Colores.negro, pColorSombra: Colores.blanco),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              player['partidas']?.toString() ?? '',
              style: Textos.chewy(12, Colores.negro, pColorSombra: Colores.blanco),
              textAlign: TextAlign.center,
            ),
          ),

          Expanded(
            flex: 1,
            child: Text(
              SrvFechas.segundosAMinutosYSegundos(player['tiempo_record'] ?? 0),
              style: Textos.chewy(12, Colores.negro, pColorSombra: Colores.blanco),
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
        // Group Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          color: Colores.fondo,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left-aligned thermometer
              Text(
                '🌡️ ${InfoNiveles.nivel[EstadoDelJuego.nivel]['titulo']}',
                style: Textos.luckiestGuy(22, Colores.segundo, pColorSombra: Colores.fondo),
              ),

              // Centered part (now without the cup)
              Expanded(
                child: Text(
                  '${group.title} • ${group.players.length}',
                  textAlign: TextAlign.center,
                  style: Textos.luckiestGuy(18, Colores.primero, pColorSombra: Colores.fondo),
                ),
              ),

              // Right-aligned cup (bigger)
              Text(group.giphy, style: Textos.luckiestGuy(32, Colores.primero, pColorSombra: Colores.fondo)),
            ],
          ),
        ),
        // Group Header Row (same as your original header)
        Container(
          padding: EdgeInsets.all(8),
          color: Colores.fondo,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Text('👤', style: Textos.chewy(18, Colores.negro, pColorSombra: Colores.fondo)),
              ),
              Expanded(
                flex: 2,
                child: Text('📍', style: Textos.chewy(18, Colores.negro, pColorSombra: Colores.fondo)),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '🏅',
                  style: Textos.chewy(18, Colores.negro, pColorSombra: Colores.fondo),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '🕹️',
                  style: Textos.chewy(18, Colores.negro, pColorSombra: Colores.fondo),
                  textAlign: TextAlign.center,
                ),
              ),

              Expanded(
                flex: 1,
                child: Text(
                  '⌚',
                  style: Textos.chewy(18, Colores.negro, pColorSombra: Colores.fondo),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

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
    return Scaffold(
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
            return Center(child: Text('No hay datos disponibles'));
          }

          final allPlayers = snapshot.data!;
          final groups = _crearGruposDeJugadores(allPlayers);

          return ListView(children: groups.map((group) => _buildGroupSection(group)).toList());
        },
      ),
    );
  }
}
