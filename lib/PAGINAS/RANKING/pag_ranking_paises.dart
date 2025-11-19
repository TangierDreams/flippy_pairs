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
  // Creamos una lista con los distintos grupos de paises: buenos, normales y
  // malos
  //----------------------------------------------------------------------------
  List<PlayerGroup> _crearGruposDePaises(List<Map<String, dynamic>> pJugadores) {
    final gruposDePaises = <PlayerGroup>[];
    final totalPaises = pJugadores.length;

    if (totalPaises == 0) return gruposDePaises;

    final topPaisesCount = (totalPaises * 0.1).ceil();
    final badPaisesCount = (totalPaises * 0.1).ceil();
    final normalPaisesCount = totalPaises - topPaisesCount - badPaisesCount;

    final adjustedNormalPaisesCount = normalPaisesCount >= 0 ? normalPaisesCount : 0;
    final adjustedBadPaisesCount = normalPaisesCount >= 0 ? badPaisesCount : totalPaises - topPaisesCount;

    // Sublista de los mejores paises, titulo e icono:
    if (topPaisesCount > 0) {
      gruposDePaises.add(
        PlayerGroup(
          posicion: 1,
          title: SrvTraducciones.get('primerosp'),
          players: pJugadores.sublist(0, topPaisesCount),
          giphy: '🏆',
        ),
      );
    }

    // Sublista de paises normales, titulo e icono:
    if (adjustedNormalPaisesCount > 0 && topPaisesCount + adjustedNormalPaisesCount <= totalPaises) {
      gruposDePaises.add(
        PlayerGroup(
          posicion: 2,
          title: SrvTraducciones.get('segundosp'),
          players: pJugadores.sublist(topPaisesCount, topPaisesCount + adjustedNormalPaisesCount),
          giphy: '⚖️',
        ),
      );
    }

    // Sublista de paises petardos, titulo e icono:
    if (adjustedBadPaisesCount > 0) {
      gruposDePaises.add(
        PlayerGroup(
          posicion: 3,
          title: SrvTraducciones.get('tercerosp'),
          players: pJugadores.sublist(totalPaises - adjustedBadPaisesCount),
          giphy: '🐢',
        ),
      );
    }

    // Si no hay suficientes paises como para hacer grupos, los colocamos todos en una lista:
    if (gruposDePaises.isEmpty) {
      gruposDePaises.add(
        PlayerGroup(posicion: 1, title: SrvTraducciones.get('todos'), players: pJugadores, giphy: '🚀'),
      );
    }

    return gruposDePaises;
  }

  //----------------------------------------------------------------------------
  // Widget para mostrar la fila de un pais.
  //----------------------------------------------------------------------------

  Widget _montarRegistroPais(Map<String, dynamic> pPais, {required bool pIsTopGroup, required Color pColorDeTexto}) {
    posicion += 1;

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
              style: SrvFuentes.chewy(context, 16, pColorDeTexto, pColorSombra: Colors.transparent),
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
                    'https://flagcdn.com/64x48/${pPais['pais']?.toLowerCase()}.png',
                    width: 24, // Bandera más grande
                    height: 18,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 24,
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
                    pPais['nombre']?.toString() ?? '',
                    style: SrvFuentes.chewy(context, 16, pColorDeTexto, pColorSombra: Colors.transparent),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(), // Empuja los puntos a la derecha
          // 3. Puntuación (Texto de acento)
          Text(
            '${pPais['puntos']?.toString() ?? ''} Pts',
            style: SrvFuentes.chewy(context, 16, pColorDeTexto, pColorSombra: Colors.transparent),
            textAlign: TextAlign.right,
          ),

          // 4. Glifo extra (Trofeo, Balanza o Tortuga)
          // El grupo TOP usa '✨', los otros usan su propio glifo de grupo.
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              pIsTopGroup && posicion <= 3 ? '✨' : '', // Si es TOP 3, usa '✨', sino vacío
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  // Widget para montar el título principal del listado.
  //----------------------------------------------------------------------------

  Widget _montarTituloPrincipal(BuildContext context) {
    // Colores del título principal
    final Color toolbarColor = SrvColores.get(context, ColorKey.principal);

    const double iconSize = 60.0;
    //const double iconPadding = 15.0;
    //const double totalIconArea = iconSize / 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: toolbarColor,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // 2. Icono Principal (Circulito superpuesto)
            Positioned(
              left: 0,
              child: Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: toolbarColor,
                  shape: BoxShape.circle,
                  // ¡CORREGIDO! Eliminamos el borde blanco
                  // border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 2.0,),
                ),
                alignment: Alignment.center,
                child: const Text('🌎', style: TextStyle(fontSize: 32)),
              ),
            ),

            // 1. Contenedor del Título
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: toolbarColor.withValues(alpha: 0.0),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Countries Competition",
                      style: SrvFuentes.luckiestGuy(
                        context,
                        22,
                        SrvColores.get(context, ColorKey.destacado),
                        pColorSombra: SrvColores.get(context, ColorKey.negro),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // LÍNEA 2: "Nivel 3x2" (Centrado en la línea)
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Nivel ${InfoNiveles.nivel[EstadoDelJuego.nivel]['titulo']}",
                      style: SrvFuentes.luckiestGuy(context, 20, Colors.white, pColorSombra: null),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center, // Aseguramos que el texto esté centrado
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  //----------------------------------------------------------------------------
  // Widget para montar el título de cada grupo.
  //----------------------------------------------------------------------------

  Widget _montarTituloDelGrupo(
    PlayerGroup pGrupo, {
    required Color pColorDelTitulo,
    required Color pColorDeTexto,
    required Color pColorDeFondo,
    required Color pColorPrincipal,
  }) {
    const double iconSize = 48.0;
    const double paddingTitulo = iconSize / 2;

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          //----------------------
          // Contenedor del Título
          //----------------------
          Padding(
            padding: const EdgeInsets.only(left: paddingTitulo),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: pColorDeFondo,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    pGrupo.title,
                    textAlign: TextAlign.left,
                    style: SrvFuentes.chewy(context, 25, pColorDelTitulo, pColorSombra: null),
                  ),
                ],
              ),
            ),
          ),

          //----------------------------------------
          // Icono del Grupo (circulito superpuesto)
          //----------------------------------------
          Positioned(
            left: 0,
            child: Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(color: pColorPrincipal, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(pGrupo.giphy, style: const TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  // Widget para montar los elementos del container del grupo
  //----------------------------------------------------------------------------

  Widget _montarGrupos(PlayerGroup pGrupo) {
    BoxDecoration decoration;
    Color grupoColorDelTitulo;
    Color grupoColorPrincipal;
    Color grupoColorDeTexto;
    Color grupoSegundoContenedor;
    Color grupoColorCabecera;

    if (pGrupo.posicion == 1) {
      //--------------------------
      // El primer grupo de paises
      //--------------------------
      grupoColorDelTitulo = Color.fromARGB(255, 247, 186, 45);
      grupoColorDeTexto = Colors.white;
      grupoSegundoContenedor = Colors.black.withValues(alpha: 0.2);
      grupoColorCabecera = const Color(0xFF4C3AA8);
      grupoColorPrincipal = const Color(0xFF6B4EEA);
      decoration = BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: grupoColorPrincipal);
    } else if (pGrupo.posicion == 2) {
      //---------------------------
      // El sengudo grupo de paises
      //---------------------------
      grupoColorDelTitulo = Color(0xFFbae589);
      grupoColorDeTexto = Colors.black87;
      grupoSegundoContenedor = const Color(0xFF4CA04C);
      grupoColorCabecera = const Color.fromARGB(255, 51, 122, 52);
      grupoColorPrincipal = const Color.fromARGB(255, 103, 212, 105);
      decoration = BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: grupoColorPrincipal);
    } else {
      //--------------------------
      // El tercer grupo de paises
      //--------------------------
      grupoColorDelTitulo = Color.fromARGB(255, 255, 184, 3);
      grupoColorDeTexto = Colors.black87;
      grupoSegundoContenedor = const Color(0xFFD88540);
      grupoColorCabecera = const Color(0xFFA8632C);
      grupoColorPrincipal = const Color.fromARGB(255, 249, 160, 88);
      decoration = BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: grupoColorPrincipal);
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
            _montarTituloDelGrupo(
              pGrupo,
              pColorDelTitulo: grupoColorDelTitulo,
              pColorDeTexto: grupoColorDeTexto,
              pColorDeFondo: grupoColorCabecera,
              pColorPrincipal: grupoColorPrincipal,
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Container(
                decoration: BoxDecoration(color: grupoSegundoContenedor, borderRadius: BorderRadius.circular(10.0)),

                child: Column(
                  children: [
                    ...pGrupo.players.map(
                      (player) => _montarRegistroPais(
                        player,
                        pIsTopGroup: pGrupo.posicion == 1,
                        pColorDeTexto: grupoColorDeTexto,
                      ),
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
    posicion = 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
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

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 24, 19, 97), // 1. Azul muy oscuro (Casi negro)
                  Color(0xFF4CA04C), // 2. Verde (o Menta oscura, punto medio)
                  Color(0xFFE9934B), // 3. Naranja (Parte inferior)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // Puedes añadir 'stops' si quieres controlar dónde cambia cada color:
                stops: [0.0, 0.7, 0.9],
              ),
              // Si añades un patrón de estrellas (tile) como imagen:
              // image: DecorationImage(image: AssetImage('assets/star_pattern.png'), repeat: ImageRepeat.repeat),
            ),
            child: Column(
              children: [
                // Título del listado:
                _montarTituloPrincipal(context),

                // Lista de grupos con las tarjetas bonitas
                Expanded(child: ListView(children: groups.map((group) => _montarGrupos(group)).toList())),
              ],
            ),
          );
        },
      ),
    );
  }
}
