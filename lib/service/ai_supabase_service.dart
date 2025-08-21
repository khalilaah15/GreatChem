import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class AISupabaseService {
  final _client = Supabase.instance.client;

  // Cari faktor laju reaksi berdasarkan permasalahan
  Future<List<Map<String, dynamic>>> searchKlasifikasi(String query) async {
    final response = await _client
        .from('klasifikasi')
        .select()
        .ilike('permasalahan', '%$query%'); // ilike = case-insensitive

    return List<Map<String, dynamic>>.from(response);
  }

  // Cari penjelasan istilah
  Future<List<Map<String, dynamic>>> searchIstilah(String query) async {
    final response = await _client
        .from('istilah')
        .select()
        .ilike('istilah_kimia', '%$query%');

    return List<Map<String, dynamic>>.from(response);
  }
}
