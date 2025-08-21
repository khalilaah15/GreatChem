import 'package:supabase_flutter/supabase_flutter.dart';

// Inisialisasi Supabase di main.dart
// final supabase = Supabase.instance.client;

class PeerAssessmentService {
  final supabase = Supabase.instance.client;

  // --- UNTUK SISWA ---

  // 1. Mengambil daftar teman (siswa lain)
  Future<List<Map<String, dynamic>>> getOtherStudents() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('profiles')
          .select('id, name')
          .eq('role', 'siswa')
          .neq('id', userId);
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      // Handle error
      print('Error fetching students: $e');
      return [];
    }
  }

  // 2. Cek apakah sudah pernah menilai teman tertentu
  Future<bool> hasAlreadyAssessed(String assessedUserId) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('penilaian_sebaya')
          .select('id')
          .eq('penilai_id', userId)
          .eq('dinilai_id', assessedUserId)
          .limit(1);
      
      return (response as List).isNotEmpty;
    } catch (e) {
      print('Error checking assessment: $e');
      return false;
    }
  }

  // 3. Submit penilaian
  Future<void> submitAssessment({
    required String assessedUserId,
    required Map<String, int> scores,
  }) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final totalScore = scores.values.reduce((a, b) => a + b);

      await supabase.from('penilaian_sebaya').insert({
        'penilai_id': userId,
        'dinilai_id': assessedUserId,
        'skor': scores, // Map akan otomatis diconvert ke JSONB
        'total_skor': totalScore,
      });
    } catch (e) {
      // Handle error, misalnya karena constraint unique_penilaian
      print('Error submitting assessment: $e');
      throw Exception('Gagal mengirim penilaian.');
    }
  }


  // --- UNTUK GURU ---

  // 4. Mengambil hasil penilaian untuk siswa tertentu
  Future<List<Map<String, dynamic>>> getAssessmentResults(String studentId) async {
    try {
      final response = await supabase.rpc(
        'get_penilaian_results',
        params: {'student_id': studentId},
      );
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('Error fetching results: $e');
      return [];
    }
  }
}
