import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class SrvSupabase {
  static Future<void> grabarPartida({
    required String pId,
    required int pNivel,
    required String pNombre,
    required String pPais,
    required String pCiudad,
    required int pPuntos,
    required int pTiempo,
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
    };

    try {
      await supabase.rpc("upsert_flippy_points", params: params);
      debugPrint('Registro de Supabase grabado');
    } on PostgrestException catch (e) {
      debugPrint('Error de Supabase (RPC): ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error inesperado de Supabase al guardar el registro: $e');
      rethrow;
    }
  }
}
