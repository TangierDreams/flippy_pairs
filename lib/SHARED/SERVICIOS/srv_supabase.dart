import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

final supabase = Supabase.instance.client;


class SrvSupabase {

  Future<void> getLeagues() async {
    try {
      final response = await supabase
          .from('betpoint_leagues')
          .select();

      // You can print the data directly to the debug console
      debugPrint('Fetched clients: $response');
    } on PostgrestException catch (e) {
      debugPrint('Error fetching clients: ${e.message}');
    } catch (e) {
      debugPrint('An unexpected error occurred: $e');
    }
  }
}