import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class TugasSupabaseService {
  final _client = Supabase.instance.client;

  // Upload file tugas
  Future<void> uploadTugas(String namaKelompok, File file) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}";

    // Upload ke bucket "diskusi_kelompok"
    await _client.storage.from('diskusi_kelompok').upload(fileName, file);

    // Ambil public URL
    final fileUrl = _client.storage
        .from('diskusi_kelompok')
        .getPublicUrl(fileName);

    // Simpan metadata ke tabel
    await _client.from('diskusi_kelompok').insert({
      'nama_kelompok': namaKelompok,
      'file_url': fileUrl,
    });
  }

  // Ambil daftar tugas
  Future<List<Map<String, dynamic>>> getTugas() async {
    final res = await _client
        .from('diskusi_kelompok')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }
}
