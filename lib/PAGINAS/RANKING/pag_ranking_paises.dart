//------------------------------------------------------------------------------
// PAGINA DONDE MOSTRAMOS EL RANKING POR PAISES DE LA COMPETICION MUNDIAL FLIPPY.
// (VERSIÓN CON ESTILO DE TARJETAS Y GRUPOS)
//------------------------------------------------------------------------------

import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PAGINAS/RANKING/MODELOS/player_group.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_datos_generales.dart';
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

//==============================================================================
// CLASE PRINCIPAL
//==============================================================================

class _PagRankingPaisesState extends State<PagRankingPaises> {
  // Aquí almacenamos la lista completa de paises:
  late Future<List<Map<String, dynamic>>> listaRanking;
  int posicion = 0; // Posición en la lista:

  //----------------------------------------------------------------------------
  // Tareas al iniciar la página.
  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    SrvLogger.grabarLog('pag_ranking_paises', 'initState()', 'Entramos en la pagina de ranking de paises');
    listaRanking = SrvSupabase.obtenerPaisesFlippy();
  }

  //----------------------------------------------------------------------------
  // Tareas antes de abandonar la página.
  //----------------------------------------------------------------------------

  @override
  void dispose() {
    SrvLogger.grabarLog('pag_ranking_paises', 'dispose()', 'Salimos de la pagina de ranking de paises');
    super.dispose();
  }

  //----------------------------------------------------------------------------
  // WIDGET PRINCIPAL.
  //----------------------------------------------------------------------------

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
          final groups = _SupportFunctions()._crearGruposDePaises(allPlayers);

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  SrvColores.get(context, ColorKey.degradadoPantalla1),
                  SrvColores.get(context, ColorKey.degradadoPantalla2),
                  SrvColores.get(context, ColorKey.degradadoPantalla3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // Puedes añadir 'stops' si quieres controlar dónde cambia cada color:
                stops: [0.0, 0.7, 0.9],
              ),
              // Si añades un patrón de estrellas (tile) como imagen:
              image: DecorationImage(image: AssetImage(SrvDatosGenerales.fondoPantalla), repeat: ImageRepeat.repeat),
            ),
            child: Column(
              children: [
                // Título del listado:
                _montarTituloPrincipal(context),

                // Lista de grupos con las tarjetas bonitas
                Expanded(child: ListView(children: [for (int i = 0; i < groups.length; i++) _montarGrupos(groups[i])])),
              ],
            ),
          );
        },
      ),
    );
  }

  //----------------------------------------------------------------------------
  // Widget para montar los elementos del contenedor de cada grupo
  //----------------------------------------------------------------------------

  Widget _montarGrupos(PlayerGroup pGrupo) {
    BoxDecoration decoration;
    Color gColorContPrincipal;
    Color gColorContInterior;
    Color gColorContCabecera;
    Color gColorDelTitulo;
    Color gColorDelTexto;

    if (pGrupo.posicion == 1) {
      //--------------------------
      // El primer grupo de paises
      //--------------------------
      gColorContPrincipal = SrvColores.get(context, ColorKey.ranking1Contenedor);
      gColorContInterior = SrvColores.get(context, ColorKey.ranking1ContenedorInterior);
      gColorContCabecera = SrvColores.get(context, ColorKey.ranking1ContenedorInterior);
      gColorDelTitulo = SrvColores.get(context, ColorKey.ranking1Titulo);
      gColorDelTexto = SrvColores.get(context, ColorKey.ranking1Texto);
      decoration = BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: gColorContPrincipal);
    } else if (pGrupo.posicion == 2) {
      //---------------------------
      // El segundo grupo de paises
      //---------------------------
      gColorContPrincipal = SrvColores.get(context, ColorKey.ranking2Contenedor);
      gColorContInterior = SrvColores.get(context, ColorKey.ranking2ContenedorInterior);
      gColorContCabecera = SrvColores.get(context, ColorKey.ranking2ContenedorInterior);
      gColorDelTitulo = SrvColores.get(context, ColorKey.ranking2Titulo);
      gColorDelTexto = SrvColores.get(context, ColorKey.ranking2Texto);
      decoration = BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: gColorContPrincipal);
    } else {
      //--------------------------
      // El tercer grupo de paises
      //--------------------------
      gColorContPrincipal = SrvColores.get(context, ColorKey.ranking4Contenedor);
      gColorContInterior = SrvColores.get(context, ColorKey.ranking4ContenedorInterior);
      gColorContCabecera = SrvColores.get(context, ColorKey.ranking4ContenedorInterior);
      gColorDelTitulo = SrvColores.get(context, ColorKey.ranking4Titulo);
      gColorDelTexto = SrvColores.get(context, ColorKey.ranking4Texto);
      decoration = BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: gColorContPrincipal);
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
              pColorDelTitulo: gColorDelTitulo,
              pColorDeTexto: gColorDelTexto,
              pColorDeFondo: gColorContCabecera,
              pColorPrincipal: gColorContPrincipal,
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Container(
                decoration: BoxDecoration(color: gColorContInterior, borderRadius: BorderRadius.circular(10.0)),

                child: Column(
                  children: [
                    for (int i = 0; i < pGrupo.players.length; i++)
                      _montarRegistroPais(pGrupo.players[i], i, pColorDeTexto: gColorDelTexto),
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

  //----------------------------------------------------------------------------
  // Widget para montar el título principal del listado.
  //----------------------------------------------------------------------------

  Widget _montarTituloPrincipal(BuildContext context) {
    const double iconSize = 60.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: SrvColores.get(context, ColorKey.principal),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: SrvColores.get(context, ColorKey.negro),
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
                decoration: BoxDecoration(color: SrvColores.get(context, ColorKey.principal), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Text('🌎', style: TextStyle(fontSize: 32)),
              ),
            ),

            // 1. Contenedor del Título
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: SrvColores.get(context, ColorKey.principal).withValues(alpha: 0.0),
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
  // Widget para mostrar la fila de un pais.
  //----------------------------------------------------------------------------

  Widget _montarRegistroPais(Map<String, dynamic> pPais, int pPosRelativa, {required Color pColorDeTexto}) {
    posicion += 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          //-----------------------
          // Posicion en el ranking
          //-----------------------
          Container(
            alignment: Alignment.centerLeft,
            width: 30, // Ancho fijo para la posición
            child: Text(
              posicion.toString(),
              style: SrvFuentes.chewy(context, 16, pColorDeTexto, pColorSombra: Colors.transparent),
            ),
          ),

          //--------------------------
          // Bandera y Nombre del País
          //--------------------------
          Expanded(
            flex: 4,
            child: Row(
              children: [
                //--------
                // Bandera
                //--------
                ClipRRect(
                  borderRadius: BorderRadius.circular(2.0),
                  child: Image.network(
                    '${SrvDatosGenerales.urlBanderas}${pPais['pais']?.toLowerCase()}.png',
                    width: 24,
                    height: 18,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      //------------------
                      // Si no hay bandera
                      //------------------
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

                //----------------
                // Nombre del País
                //----------------
                Flexible(
                  child: Text(
                    pPais['nombre']?.toString() ?? '',
                    style: SrvFuentes.chewy(context, 16, pColorDeTexto),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(), // Empuja los puntos a la derecha
          //-----------
          // Puntuación
          //-----------
          Text(
            '${pPais['puntos']?.toString() ?? ''} Pts',
            style: SrvFuentes.chewy(context, 16, pColorDeTexto),
            textAlign: TextAlign.right,
          ),

          //--------------------------
          // Destacamos los 3 primeros
          //--------------------------
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: pPosRelativa < 3
                ? Text('✨', style: const TextStyle(fontSize: 18))
                : Text('✨', style: const TextStyle(fontSize: 18, color: Colors.transparent)),
          ),
        ],
      ),
    );
  }
}

//==============================================================================
// FUNCIONES DE SOPORTE
//==============================================================================

class _SupportFunctions {
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
}
