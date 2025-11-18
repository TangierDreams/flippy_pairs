//------------------------------------------------------------------------------
// PAGINA DONDE MOSTRAMOS EL RANKING POR PAISES DE LA COMPETICION MUNDIAL FLIPPY.
// (VERSIÓN CON ESTILO DE TARJETAS Y GRUPOS)
//------------------------------------------------------------------------------

import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PAGINAS/RANKING/MODELOS/player_group.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fuentes.dart';
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
  int posicion = 0; // Posición en la lista:

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
  // Creamos una lista con los distintos grupos de jugadores: (Lógica sin cambios)
  //----------------------------------------------------------------------------
  List<PlayerGroup> _crearGruposDePaises(List<Map<String, dynamic>> pJugadores) {
    // ... (Tu lógica original de creación de grupos queda aquí, sin cambios)
    final gruposDePaises = <PlayerGroup>[];
    final totalPaises = pJugadores.length;

    if (totalPaises == 0) return gruposDePaises;

    final topPaisesCount = (totalPaises * 0.1).ceil();
    final badPaisesCount = (totalPaises * 0.1).ceil();
    final normalPaisesCount = totalPaises - topPaisesCount - badPaisesCount;

    final adjustedNormalPaisesCount = normalPaisesCount >= 0 ? normalPaisesCount : 0;
    final adjustedBadPaisesCount = normalPaisesCount >= 0 ? badPaisesCount : totalPaises - topPaisesCount;

    // Top Paises (con nuevos nombres y glifos sugeridos)
    if (topPaisesCount > 0) {
      gruposDePaises.add(
        PlayerGroup(
          title: SrvTraducciones.get('Ases Ascendentes'), // Usando tus keys de traducción
          players: pJugadores.sublist(0, topPaisesCount),
          giphy: '🏆', // Glifo Trofeo para el TOP
        ),
      );
    }

    // Normal Paises
    if (adjustedNormalPaisesCount > 0 && topPaisesCount + adjustedNormalPaisesCount <= totalPaises) {
      gruposDePaises.add(
        PlayerGroup(
          title: SrvTraducciones.get('Guardianes del Equilibrio'),
          players: pJugadores.sublist(topPaisesCount, topPaisesCount + adjustedNormalPaisesCount),
          giphy: '⚖️', // Glifo Balanza
        ),
      );
    }

    // Bad Players
    if (adjustedBadPaisesCount > 0) {
      gruposDePaises.add(
        PlayerGroup(
          title: SrvTraducciones.get('Club de la Redención'),
          players: pJugadores.sublist(totalPaises - adjustedBadPaisesCount),
          giphy: '🐢', // Glifo Tortuga
        ),
      );
    }

    if (gruposDePaises.isEmpty) {
      gruposDePaises.add(PlayerGroup(title: SrvTraducciones.get('todos'), players: pJugadores, giphy: '🚀'));
    }

    return gruposDePaises;
  }

  //----------------------------------------------------------------------------
  // NUEVO WIDGET AUXILIAR: Encabezado del Grupo (Título y Glifo)
  //----------------------------------------------------------------------------

  Widget _buildGroupHeader(PlayerGroup group, {required Color groupTextColor, required Color headerBackgroundColor}) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 1. Icono del Grupo
          Text(group.giphy, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 10),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),

              // --- DECORACIÓN DE LA BANDEJA ---
              decoration: BoxDecoration(
                color: headerBackgroundColor, // Usamos el color oscuro secundario
                borderRadius: const BorderRadius.only(
                  // Izquierda: esquina suave para la "media luna"
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  // Derecha: esquina bien redondeada
                  topRight: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),

              // --- FIN DECORACIÓN ---

              // 2. Texto del Título del Grupo
              child: Text(
                group.title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: groupTextColor, // Color definido por el grupo (Blanco o Negro)
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  // Widget para mostrar la fila de un jugador
  //----------------------------------------------------------------------------

  Widget _mostrarJugador(Map<String, dynamic> player, {required bool isTopGroup, required Color groupTextColor}) {
    posicion += 1;

    // Define el color del texto y acento basado en el grupo
    final textColor = groupTextColor;
    final accentColor = isTopGroup ? Colors.white70 : SrvColores.get(context, ColorKey.texto);
    final textShadowColor = isTopGroup ? Colors.transparent : SrvColores.get(context, ColorKey.fondo);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // 1. Columna de posición
          Container(
            alignment: Alignment.centerLeft,
            width: 30, // Ancho fijo para la posición
            child: Text(
              posicion.toString(),
              style: SrvFuentes.chewy(context, 16, textColor, pColorSombra: Colors.transparent),
            ),
          ),

          // 2. Bandera y Nombre del País (Simplificado y estilizado)
          Expanded(
            flex: 4,
            child: Row(
              children: [
                // Country flag
                ClipRRect(
                  borderRadius: BorderRadius.circular(2.0),
                  child: Image.network(
                    'https://flagcdn.com/16x12/${player['pais']?.toLowerCase()}.png',
                    width: 24, // Bandera más grande
                    height: 18,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 24, // Ajustamos el tamaño del fallback
                        height: 18,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error_outline, size: 12, color: Colors.grey),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),

                // Nombre del País
                Flexible(
                  child: Text(
                    player['nombre']?.toString() ?? '',
                    style: SrvFuentes.chewy(context, 16, textColor, pColorSombra: Colors.transparent),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(), // Empuja los puntos a la derecha
          // 3. Puntuación (Texto de acento)
          Text(
            '${player['puntos']?.toString() ?? ''} Pts',
            //style: TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.w600),
            style: SrvFuentes.chewy(context, 16, textColor, pColorSombra: Colors.transparent),
            textAlign: TextAlign.right,
          ),

          // 4. Glifo extra (Trofeo, Balanza o Tortuga)
          // El grupo TOP usa '✨', los otros usan su propio glifo de grupo.
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              isTopGroup && posicion <= 3 ? '✨' : '', // Si es TOP 3, usa '✨', sino vacío
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  // Widget para construir el título y contenido de un grupo.
  //----------------------------------------------------------------------------

  Widget _buildGroupSection(PlayerGroup group) {
    // 1. Definición de estilos por grupo
    BoxDecoration decoration;
    Color groupTextColor;
    Color secondaryBackgroundColor;
    Color headerBackgroundColor;

    if (group.giphy == '🏆') {
      // ASES ASCENDENTES (TOP) - Degradado Morado/Azul
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: const LinearGradient(
          colors: [Color(0xFF6B4EEA), Color(0xFF5560E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      );
      groupTextColor = Colors.white;
      secondaryBackgroundColor = Colors.black.withValues(alpha: 0.2);
      headerBackgroundColor = const Color(0xFF4C3AA8);
    } else if (group.giphy == '⚖️') {
      // GUARDIANES DEL EQUILIBRIO (NORMALES) - Color sólido Verde
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: const Color(0xFF58B65A).withValues(alpha: 0.8),
      );
      groupTextColor = Colors.black87;
      secondaryBackgroundColor = const Color(0xFF4CA04C).withValues(alpha: 0.8);
      headerBackgroundColor = const Color(0xFF3B8E3D);
    } else {
      // '🐢' o cualquier otro
      // CLUB DE LA REDENCIÓN (MALOS) - Color sólido Naranja
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: const Color(0xFFE9934B).withValues(alpha: 0.8),
      );
      groupTextColor = Colors.black87;
      secondaryBackgroundColor = const Color(0xFFD88540).withValues(alpha: 0.8);
      headerBackgroundColor = const Color(0xFFA8632C);
    }

    // 2. Estructura de la tarjeta
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Encabezado del Grupo
            const SizedBox(height: 10),
            _buildGroupHeader(group, groupTextColor: groupTextColor, headerBackgroundColor: headerBackgroundColor),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: secondaryBackgroundColor, // Fondo interior
                  borderRadius: BorderRadius.circular(10.0),
                ),

                child: Column(
                  children: [
                    ...group.players.map(
                      (player) =>
                          _mostrarJugador(player, isTopGroup: group.giphy == '🏆', groupTextColor: groupTextColor),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Listado de Jugadores
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // **IMPORTANTE: REINICIAMOS LA POSICIÓN AQUÍ**
    posicion = 0;

    return Scaffold(
      backgroundColor: SrvColores.get(context, ColorKey.fondo),
      appBar: WidToolbar(showMenuButton: false, showBackButton: true, subtitle: SrvTraducciones.get('subtitulo_app')),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: listaRanking,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(SrvTraducciones.get('sin_datos')));
          }

          final allPlayers = snapshot.data!;
          final groups = _crearGruposDePaises(allPlayers);

          return Column(
            children: [
              // Mensaje de posición del jugador (tu widget superior original)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: SrvColores.get(context, ColorKey.fondo),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Countries ",
                            style: SrvFuentes.luckiestGuy(
                              context,
                              24,
                              SrvColores.get(context, ColorKey.destacado),
                              pColorSombra: SrvColores.get(context, ColorKey.fondo),
                            ),
                          ),
                          TextSpan(
                            text: "Competition ${InfoNiveles.nivel[EstadoDelJuego.nivel]['titulo']}",
                            style: SrvFuentes.luckiestGuy(
                              context,
                              22,
                              SrvColores.get(context, ColorKey.principal),
                              pColorSombra: SrvColores.get(context, ColorKey.fondo),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Lista de grupos con las tarjetas bonitas
              Expanded(child: ListView(children: groups.map((group) => _buildGroupSection(group)).toList())),
            ],
          );
        },
      ),
    );
  }
}
