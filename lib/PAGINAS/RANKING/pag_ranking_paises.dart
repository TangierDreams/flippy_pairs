//------------------------------------------------------------------------------
// PAGINA DONDE MOSTRAMOS EL RANKING POR PAISES DE LA COMPETICION MUNDIAL FLIPPY.
//------------------------------------------------------------------------------

import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PAGINAS/RANKING/MODELOS/player_group.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fechas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_supabase.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_traducciones.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flutter/material.dart';

class PagRankingPaises extends StatefulWidget {
  const PagRankingPaises({super.key});

  @override
  State<PagRankingPaises> createState() => _PagRankingPaisesState();
}

class _PagRankingPaisesState extends State<PagRankingPaises> {
  // Aquí almacenamos la lista completa de paises:
  late Future<List<Map<String, dynamic>>> listaRanking;

  // Mi id:

  //String miId = SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: '');

  // Posición en la lista:

  int posicion = 0;

  //----------------------------------------------------------------------------
  // Buscamos la posición del usuario en la lista
  //----------------------------------------------------------------------------

  // int _encontrarMiPosicion(List<Map<String, dynamic>> jugadores) {
  //   for (int i = 0; i < jugadores.length; i++) {
  //     if (jugadores[i]['id'] == miId) {
  //       return i + 1; // +1 porque las posiciones empiezan en 1
  //     }
  //   }
  //   return 0; // Si no se encuentra
  // }

  @override
  void initState() {
    super.initState();
    SrvLogger.grabarLog('pag_ranking_paises', 'initState()', 'Entramos en la pagina de ranking de paises');
    listaRanking = SrvSupabase.obtenerPaisesFlippy();
  }

  @override
  void dispose() {
    SrvLogger.grabarLog('pag_ranking_paises', 'dispose()', 'Salimos de la pagina de ranking de paises');
    super.dispose();
  }

  //----------------------------------------------------------------------------
  // Creamos una lista con los distintos grupos de jugadores:
  // 10% - Top players
  // 10% - Best players
  // 70% - Normal players
  // 10% - Bad players
  //----------------------------------------------------------------------------
  List<PlayerGroup> _crearGruposDePaises(List<Map<String, dynamic>> pJugadores) {
    final gruposDePaises = <PlayerGroup>[];
    final totalPaises = pJugadores.length;

    if (totalPaises == 0) return gruposDePaises;

    // Calculamos el numero de jugadores de cada grupo:

    final topPaisesCount = (totalPaises * 0.1).ceil();
    final badPaisesCount = (totalPaises * 0.1).ceil();
    final normalPaisesCount = totalPaises - topPaisesCount - badPaisesCount;

    // Nos aseguramos de que los "normal players" no queden en negativo:

    final adjustedNormalPaisesCount = normalPaisesCount >= 0 ? normalPaisesCount : 0;
    final adjustedBadPaisesCount = normalPaisesCount >= 0 ? badPaisesCount : totalPaises - topPaisesCount;

    //-------------------------
    // Top Paises (first 10%)
    //-------------------------

    if (topPaisesCount > 0) {
      gruposDePaises.add(
        PlayerGroup(
          title: SrvTraducciones.get('primerosp'),
          players: pJugadores.sublist(0, topPaisesCount),
          giphy: '👑',
        ),
      );
    }

    //---------------------------
    // Normal Paises (next 80%)
    //---------------------------

    if (adjustedNormalPaisesCount > 0 && topPaisesCount + adjustedNormalPaisesCount <= totalPaises) {
      gruposDePaises.add(
        PlayerGroup(
          title: SrvTraducciones.get('segundosp'),
          players: pJugadores.sublist(topPaisesCount, topPaisesCount + adjustedNormalPaisesCount),
          giphy: '⚖️',
        ),
      );
    }

    //------------------------
    // Bad Players (last 10%)
    //------------------------

    if (adjustedBadPaisesCount > 0) {
      gruposDePaises.add(
        PlayerGroup(
          title: SrvTraducciones.get('tercerosp'),
          players: pJugadores.sublist(totalPaises - adjustedBadPaisesCount),
          giphy: '🐢',
        ),
      );
    }

    //----------------------------------------------------
    // Si hay muy pocos jugadores, montamos un solo grupo.
    //----------------------------------------------------

    if (gruposDePaises.isEmpty) {
      gruposDePaises.add(PlayerGroup(title: SrvTraducciones.get('todos'), players: pJugadores, giphy: '🚀'));
    }

    return gruposDePaises;
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
              child: Text(
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
                SizedBox(width: 4), // Espacio reducido
                Text(
                  player['nombre']?.toString() ?? '',
                  style: Textos.chewy(
                    context,
                    14,
                    SrvColores.get(context, 'textos'),
                    pColorSombra: SrvColores.get(context, 'fondo'),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Columna de puntos
          Expanded(
            flex: 2,
            child: Text(
              player['puntos']?.toString() ?? '',
              style: Textos.chewy(
                context,
                16,
                SrvColores.get(context, 'textos'),
                pColorSombra: SrvColores.get(context, 'fondo'),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Columna de tiempo récord
          Expanded(
            flex: 1,
            child: Text(
              SrvFechas.segundosAMinutosYSegundos(player['tiempo'] ?? 0),
              style: Textos.chewy(
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
              style: Textos.chewy(
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
                  '🎌',
                  style: Textos.chewy(
                    context,
                    18,
                    SrvColores.get(context, 'negro'),
                    pColorSombra: SrvColores.get(context, 'fondo'),
                  ),
                ),
              ),

              Expanded(
                flex: 2, // Puntos
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
                flex: 1, // Tiempo
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
          final groups = _crearGruposDePaises(allPlayers);

          // Encontrar mi posición
          //final miPosicion = _encontrarMiPosicion(allPlayers);

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
                            text: "Countries ",
                            style: Textos.luckiestGuy(
                              context,
                              24,
                              SrvColores.get(context, 'segundo'),
                              pColorSombra: SrvColores.get(context, 'fondo'),
                            ), // Tamaño y color diferente
                          ),
                          TextSpan(
                            text: "Competition ${InfoNiveles.nivel[EstadoDelJuego.nivel]['titulo']}",
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
