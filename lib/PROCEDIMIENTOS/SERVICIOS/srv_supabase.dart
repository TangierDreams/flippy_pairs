import 'package:flippy_pairs/PAGINAS/JUEGO/MODELOS/mod_juego.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class SrvSupabase {
  //----------------------------------------------------------------------------
  // Obtener un valor de la tabla de parametros
  //----------------------------------------------------------------------------

  static Future<String> getParam(String pClave, {String pDefaultValue = ""}) async {
    try {
      final response = await supabase.from('params').select('value').eq('key', pClave).single();
      return response['value'].toString();
    } catch (e) {
      SrvLogger.grabarLog('srv_supabase', 'getParam()', 'Error al buscar la clave $pClave: $e');
      return pDefaultValue;
    }
  }

  //----------------------------------------------------------------------------
  // Grabamos los datos de una partida.
  //----------------------------------------------------------------------------

  static Future<void> grabarPartida({
    required String pId,
    required int pNivel,
    required String pNombre,
    required String pPais,
    required String pCiudad,
    required int pPuntos,
    required int pTiempo,
    required bool pGanada,
  }) async {
    // Mapeo directo de los parámetros que espera la función SQL

    final Map<String, dynamic> params = {
      '_id': pId,
      '_nivel': pNivel,
      '_nombre': pNombre,
      '_pais': pPais,
      '_ciudad': pCiudad,
      '_puntos': pPuntos,
      '_tiempo': pTiempo,
      '_ganada': pGanada,
    };

    try {
      await supabase.rpc('flippy_actualizar_puntuacion', params: params);
    } on PostgrestException catch (e) {
      SrvLogger.grabarLog('srv_supabase', 'grabarPartida()', 'Error de Supabase (RPC): ${e.message}');
      rethrow;
    } catch (e) {
      SrvLogger.grabarLog('srv_supabase', 'grabarPartida()', 'Error inesperado de Supabase al guardar el registro: $e');
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Obtenemos las puntuaciones de un dispositivo.
  //----------------------------------------------------------------------------

  static Future<List<Map<String, dynamic>>> obtenerRegFlippy({required String pId}) async {
    SrvLogger.grabarLog('srv_supabase', 'obtenerRegFlippy()', 'Buscamos los registros del usuario: $pId');
    try {
      final response = await supabase.rpc('flippy_obtener_registros_usuario', params: {'p_id': pId});

      final output = (response as List).map((e) => Map<String, dynamic>.from(e)).toList();

      return output;
    } on PostgrestException catch (e) {
      SrvLogger.grabarLog('srv_supabase', 'obtenerRegFlippy()', 'Error obteniendo los datos: ${e.message}');
      rethrow;
    } catch (e) {
      SrvLogger.grabarLog('srv_supabase', 'obtenerRegFlippy()', 'Error inesperado: $e');
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Obtenemos las puntuaciones de un dispositivo.
  //----------------------------------------------------------------------------

  static Future<List<Map<String, dynamic>>> obtenerTablaFlippy() async {
    try {
      final nivel = EstadoDelJuego.nivel;
      final response = await supabase.rpc('flippy_obtener_tabla_puntos', params: {'p_level': nivel});
      final output = (response as List).map((e) => Map<String, dynamic>.from(e)).toList();
      return output;
    } on PostgrestException catch (e) {
      SrvLogger.grabarLog('srv_supabase', 'obtenerTablaFlippy()', 'Error obteniendo los datos: ${e.message}');
      rethrow;
    } catch (e) {
      SrvLogger.grabarLog('srv_supabase', 'obtenerTablaFlippy()', 'Error inesperado: $e');
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Obtenemos las puntuaciones de un dispositivo.
  //----------------------------------------------------------------------------

  static Future<int> obtenerRankingFlippy({required String pId, required int pLevel}) async {
    SrvLogger.grabarLog(
      'srv_supabase',
      'obtenerRankingFlippy()',
      'Obtener ranking del usuario: $pId para el nivel: $pLevel',
    );
    try {
      final response = await supabase.rpc('flippy_obtener_ranking', params: {'p_id': pId, 'p_level': pLevel});
      final output = response as int;
      return output;
    } on PostgrestException catch (e) {
      SrvLogger.grabarLog('srv_supabase', 'obtenerRankingFlippy()', 'Error obteniendo los datos: ${e.message}');
      rethrow;
    } catch (e) {
      SrvLogger.grabarLog('srv_supabase', 'obtenerRankingFlippy()', 'Error inesperado: $e');
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Obtenemos las puntuaciones de un dispositivo.
  //----------------------------------------------------------------------------

  static Future<void> borrarPuntosUsuario(String pId) async {
    SrvLogger.grabarLog('srv_supabase', 'borrarPuntosUsuario()', 'Borramos la puntuacion de este usuario: $pId');
    try {
      await supabase.rpc('flippy_borrar_puntuacion', params: {'p_id': pId});
    } on PostgrestException catch (e) {
      SrvLogger.grabarLog(
        'srv_supabase',
        'borrarPuntosUsuario()',
        'Error borrando la puntuacion de este usuario: $pId',
      );
      rethrow;
    } catch (e) {
      SrvLogger.grabarLog('srv_supabase', 'borrarPuntosUsuario()', 'Error inesperado: $e');
      rethrow;
    }
  }
}
