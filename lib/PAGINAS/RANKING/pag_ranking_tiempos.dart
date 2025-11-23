//------------------------------------------------------------------------------
// PAGINA DONDE MOSTRAMOS EL RANKING POR TIEMPOS DE LA COMPETICION MUNDIAL FLIPPY.
//------------------------------------------------------------------------------

import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PAGINAS/RANKING/MODELOS/player_group.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_colores.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_datos_generales.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fechas.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_fuentes.dart';
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

//==============================================================================
// CLASE PRINCIPAL
//==============================================================================

class _PagRankingTiemposState extends State<PagRankingTiempos> {
  // Aquí almacenamos la lista completa de paises:
  late Future<List<Map<String, dynamic>>> listaRanking;
  int posicion = 0;
  String miId = '';
  List<Map<String, dynamic>> allPlayers = [];

  //----------------------------------------------------------------------------
  // Tareas al iniciar la página.
  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    SrvLogger.grabarLog('pag_ranking_tiempos', 'initState()', 'Entramos en la pagina de ranking por tiempo');
    listaRanking = SrvSupabase.obtenerTiemposFlippy();
    miId = SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: '');
  }

  //----------------------------------------------------------------------------
  // Tareas antes de abandonar la página.
  //----------------------------------------------------------------------------

  @override
  void dispose() {
    SrvLogger.grabarLog('pag_ranking_tiempos', 'dispose()', 'Salimos de la pagina de ranking por tiempo');
    super.dispose();
  }

  //----------------------------------------------------------------------------
  // WIDGET PRINCIPAL
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

          allPlayers = snapshot.data!;
          final groups = _SupportFunctions()._crearGruposDeJugadores(allPlayers);

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
                // Dónde cambia cada color:
                stops: [0.0, 0.7, 0.9],
              ),
              image: DecorationImage(image: AssetImage(SrvDatosGenerales.fondoPantalla), repeat: ImageRepeat.repeat),
            ),
            child: Column(
              children: [
                _montarTituloPrincipal(context),

                // Lista de grupos
                //Expanded(child: ListView(children: groups.map((group) => _montarGrupos(group)).toList())),
                Expanded(
                  child: ListView(
                    children: () {
                      List<Widget> listaWidgets = [];
                      for (int i = 0; i < groups.length; i++) {
                        listaWidgets.add(_montarGrupos(groups[i]));
                      }
                      return listaWidgets;
                    }(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //----------------------------------------------------------------------------
  // Widget para montar el título principal del listado.
  //----------------------------------------------------------------------------

  Widget _montarTituloPrincipal(BuildContext context) {
    final Color colorDelTitulo = SrvColores.get(context, ColorKey.principal);
    final miPosicion = _SupportFunctions().encontrarMiPosicion(allPlayers);

    const double iconSize = 60.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: colorDelTitulo,
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
            //----------------------------------------
            // Icono Principal (Circulito superpuesto)
            //----------------------------------------
            Positioned(
              left: 0,
              child: Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(color: colorDelTitulo, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Text('⏱️', style: TextStyle(fontSize: 32)),
              ),
            ),

            //----------------------
            // Contenedor del Título
            //----------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: colorDelTitulo.withValues(alpha: 0.0),
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
                      "Time Flippy Competition",
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

                  //-----------------------
                  // Línea con el nivel nxn
                  //-----------------------
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "${SrvTraducciones.get('nivel')} ${InfoNiveles.nivel[EstadoDelJuego.nivel]['titulo']}",
                      style: SrvFuentes.luckiestGuy(context, 20, Colors.white, pColorSombra: null),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center, // Aseguramos que el texto esté centrado
                    ),
                  ),

                  //----------------------------------
                  // Línea con la posición del usuario
                  //----------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.place, color: SrvColores.get(context, ColorKey.muyResaltado), size: 20),
                      SizedBox(width: 8),
                      Text(
                        miPosicion > 0
                            ? '${SrvTraducciones.get('estas_en_posicion')} $miPosicion'
                            : SrvTraducciones.get('no_has_jugado'),
                        style: SrvFuentes.chewy(context, 18, SrvColores.get(context, ColorKey.onPrincipal)),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
  // Widget para montar los elementos del contenedor de cada grupo
  //----------------------------------------------------------------------------

  Widget _montarGrupos(PlayerGroup pGrupo) {
    BoxDecoration decoration;
    Color gColorContPrincipal;
    Color gColorContInterior;
    Color gColorContCabecera;
    Color gColorDelTitulo;
    Color gColorDelTexto;
    Color gColorNeutro;

    if (pGrupo.posicion == 1) {
      //--------------------------
      // El primer grupo de jugadores
      //--------------------------
      gColorContPrincipal = SrvColores.get(context, ColorKey.ranking1Contenedor);
      gColorContInterior = SrvColores.get(context, ColorKey.ranking1ContenedorInterior);
      gColorContCabecera = SrvColores.get(context, ColorKey.ranking1ContenedorInterior);
      gColorDelTitulo = SrvColores.get(context, ColorKey.ranking1Contenedor);
      gColorDelTexto = SrvColores.get(context, ColorKey.ranking1Texto);
      gColorNeutro = SrvColores.get(context, ColorKey.ranking1Neutro);
      decoration = BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: gColorContPrincipal);
    } else if (pGrupo.posicion == 2) {
      //---------------------------
      // El segundo grupo de jugadores
      //---------------------------
      gColorContPrincipal = SrvColores.get(context, ColorKey.ranking2Contenedor);
      gColorContInterior = SrvColores.get(context, ColorKey.ranking2ContenedorInterior);
      gColorContCabecera = SrvColores.get(context, ColorKey.ranking2ContenedorInterior);
      gColorDelTitulo = SrvColores.get(context, ColorKey.ranking2Contenedor);
      gColorDelTexto = SrvColores.get(context, ColorKey.ranking2Texto);
      gColorNeutro = SrvColores.get(context, ColorKey.ranking2Neutro);
      decoration = BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: gColorContPrincipal);
    } else if (pGrupo.posicion == 3) {
      //---------------------------
      // El tercer grupo de jugadores
      //---------------------------
      gColorContPrincipal = SrvColores.get(context, ColorKey.ranking3Contenedor);
      gColorContInterior = SrvColores.get(context, ColorKey.ranking3ContenedorInterior);
      gColorContCabecera = SrvColores.get(context, ColorKey.ranking3ContenedorInterior);
      gColorDelTitulo = SrvColores.get(context, ColorKey.ranking3Contenedor);
      gColorDelTexto = SrvColores.get(context, ColorKey.ranking3Texto);
      gColorNeutro = SrvColores.get(context, ColorKey.ranking3Neutro);
      decoration = BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: gColorContPrincipal);
    } else {
      //--------------------------
      // El cuarto grupo de jugadores
      //--------------------------
      gColorContPrincipal = SrvColores.get(context, ColorKey.ranking4Contenedor);
      gColorContInterior = SrvColores.get(context, ColorKey.ranking4ContenedorInterior);
      gColorContCabecera = SrvColores.get(context, ColorKey.ranking4ContenedorInterior);
      gColorDelTitulo = SrvColores.get(context, ColorKey.ranking4Contenedor);
      gColorDelTexto = SrvColores.get(context, ColorKey.ranking4Texto);
      gColorNeutro = SrvColores.get(context, ColorKey.ranking4Neutro);
      decoration = BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: gColorContPrincipal);
    }

    //---------------------------------------
    // Estructura del contenedor de un grupo
    //---------------------------------------
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
                      _mostrarRegistroJugador(pGrupo.players[i], i, gColorDelTexto, gColorNeutro),
                    const SizedBox(height: 16),
                  ],
                ),
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
  // Widget para mostrar el registro de un jugador
  //----------------------------------------------------------------------------

  Widget _mostrarRegistroJugador(
    Map<String, dynamic> player,
    int pPosRelativa,
    Color pColorDeTexto,
    Color pColorDiscreto,
  ) {
    posicion += 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //-----------------------
          // Posición en el ranking
          //-----------------------
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: player['id'] == miId
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: SrvColores.get(context, ColorKey.principal),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        posicion.toString(),
                        style: SrvFuentes.chewy(context, 16, SrvColores.get(context, ColorKey.onPrincipal)),
                      ),
                    )
                  : Text(
                      posicion.toString(),
                      style: SrvFuentes.chewy(context, 16, pColorDeTexto, pColorSombra: Colors.transparent),
                    ),
            ),
          ),

          //----------------------------------
          // Columna del nombre y la ubicación
          //----------------------------------
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //-------------------
                // Nombre del jugador
                //-------------------
                Text(
                  player['nombre']?.toString() ?? '',
                  style: player['id'] == miId
                      ? SrvFuentes.chewy(context, 20, pColorDeTexto)
                      : SrvFuentes.chewy(context, 16, pColorDeTexto),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                // Línea 2: Ciudad y bandera
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //-----------------
                    // Bandera del país
                    //-----------------
                    Image.network(
                      '${SrvDatosGenerales.urlBanderas}${player['pais']?.toLowerCase()}.png',
                      width: 24,
                      height: 18,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        //-----------------------------
                        // Si no encontramos la bandera
                        //-----------------------------
                        return Container(
                          width: 24,
                          height: 18,
                          color: SrvColores.get(context, ColorKey.destacado),
                          child: Icon(Icons.error_outline, size: 10, color: SrvColores.get(context, ColorKey.apoyo)),
                        );
                      },
                    ),
                    SizedBox(width: 4),

                    //--------------------
                    // Nombre de la ciudad
                    //--------------------
                    Text(
                      player['ciudad']?.toString() ?? '',
                      style: player['id'] == miId
                          ? SrvFuentes.chewy(context, 16, pColorDiscreto)
                          : SrvFuentes.chewy(context, 12, pColorDiscreto),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),

          //------------------
          // Columna de tiempo
          //------------------
          Expanded(
            flex: 3,
            child: Text(
              "${SrvFechas.segundosAMinutosYSegundos(player['tiempo_record'] ?? 0)} ${SrvTraducciones.get('abrev_minutos')}",
              style: player['id'] == miId
                  ? SrvFuentes.chewy(context, 18, pColorDeTexto)
                  : SrvFuentes.chewy(context, 16, pColorDeTexto),
              textAlign: TextAlign.center,
            ),
          ),

          //--------------------------
          // Destacamos los 3 primeros
          //--------------------------
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: pPosRelativa < 3
                ? Text('🚀', style: const TextStyle(fontSize: 18))
                : Text('🚀', style: const TextStyle(fontSize: 18, color: Colors.transparent)),
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
  // Buscamos la posición del usuario en la lista
  //----------------------------------------------------------------------------
  int encontrarMiPosicion(List<Map<String, dynamic>> pJugadores) {
    String miId = SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: '');
    for (int i = 0; i < pJugadores.length; i++) {
      if (pJugadores[i]['id'] == miId) {
        return i + 1;
      }
    }
    return 0;
  }

  //----------------------------------------------------------------------------
  // Creamos una lista con los distintos grupos de jugadores: Top, Buenos,
  // normales y malos
  //----------------------------------------------------------------------------
  List<PlayerGroup> _crearGruposDeJugadores(List<Map<String, dynamic>> pJugadores) {
    final gruposDeJugadores = <PlayerGroup>[];
    final totalJugadores = pJugadores.length;
    const int porcentajeTop = 5;
    const int porcentajeBuenos = 5;
    const int porcentajeMalos = 10;

    if (totalJugadores == 0) return gruposDeJugadores;

    final numJugadoresTop = (totalJugadores * porcentajeTop / 100).ceil();
    final numJugadoresBuenos = (totalJugadores * porcentajeBuenos / 100).ceil();
    int numJugadoresMalos = (totalJugadores * porcentajeMalos / 100).ceil();
    int numJugadoresNormales = totalJugadores - numJugadoresTop - numJugadoresBuenos - numJugadoresMalos;

    // Nos aseguramos de que los "jugadores normales" no queden en negativo:

    numJugadoresNormales = numJugadoresNormales >= 0 ? numJugadoresNormales : 0;
    numJugadoresMalos = numJugadoresNormales >= 0
        ? numJugadoresMalos
        : totalJugadores - numJugadoresTop - numJugadoresBuenos;

    if (numJugadoresTop > 0) {
      gruposDeJugadores.add(
        PlayerGroup(
          posicion: 1,
          title: SrvTraducciones.get('primerost'),
          players: pJugadores.sublist(0, numJugadoresTop),
          giphy: '🚀',
        ),
      );
    }

    //------------------------
    // Good Jugadores (next 10%)
    //------------------------

    if (numJugadoresBuenos > 0 && numJugadoresTop + numJugadoresBuenos <= totalJugadores) {
      gruposDeJugadores.add(
        PlayerGroup(
          posicion: 2,
          title: SrvTraducciones.get('segundost'),
          players: pJugadores.sublist(numJugadoresTop, numJugadoresTop + numJugadoresBuenos),
          giphy: '🏎️💨',
        ),
      );
    }

    //---------------------------
    // Normal Jugadores (next 70%)
    //---------------------------

    if (numJugadoresNormales > 0 && numJugadoresTop + numJugadoresBuenos + numJugadoresNormales <= totalJugadores) {
      gruposDeJugadores.add(
        PlayerGroup(
          posicion: 3,
          title: SrvTraducciones.get('tercerost'),
          players: pJugadores.sublist(
            numJugadoresTop + numJugadoresBuenos,
            numJugadoresTop + numJugadoresBuenos + numJugadoresNormales,
          ),
          giphy: '🚴',
        ),
      );
    }

    //------------------------
    // Bad Jugadores (last 10%)
    //------------------------

    if (numJugadoresMalos > 0) {
      gruposDeJugadores.add(
        PlayerGroup(
          posicion: 4,
          title: SrvTraducciones.get('cuartost'),
          players: pJugadores.sublist(totalJugadores - numJugadoresMalos),
          giphy: '🛴',
        ),
      );
    }

    //----------------------------------------------------
    // Si hay muy pocos jugadores, montamos un solo grupo.
    //----------------------------------------------------

    if (gruposDeJugadores.isEmpty) {
      gruposDeJugadores.add(
        PlayerGroup(posicion: 1, title: SrvTraducciones.get('todos'), players: pJugadores, giphy: '🚀'),
      );
    }

    return gruposDeJugadores;
  }
}
