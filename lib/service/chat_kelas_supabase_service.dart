import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatKelasSupabaseService {
  final client = Supabase.instance.client;

  Stream<List<Map<String, dynamic>>> getMessages() {
    final controller = StreamController<List<Map<String, dynamic>>>();

    client
        .from('diskusi_kelas')
        .select()
        .order('created_at', ascending: true)
        .then((data) {
          controller.add(List<Map<String, dynamic>>.from(data));
        });

    client
        .channel('public:diskusi_kelas')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'diskusi_kelas',
          callback: (payload) async {
            final newMessage = payload.newRecord;
            final current = await client
                .from('diskusi_kelas')
                .select()
                .order('created_at', ascending: true);
            controller.add(List<Map<String, dynamic>>.from(current));
          },
        )
        .subscribe();

    return controller.stream;
  }

  // Ganti fungsi sendMessage yang lama dengan yang ini:
  Future<void> sendMessage(
    String username,
    String message,
    String userId, { // TAMBAHKAN parameter userId
    File? file,
  }) async {
    String? fileUrl;

    if (file != null) {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      await client.storage.from('diskusi_kelas').upload(fileName, file);
      fileUrl = client.storage.from('diskusi_kelas').getPublicUrl(fileName);
    }

    await client.from('diskusi_kelas').insert({
      'user_id': userId, // TAMBAHKAN userId ke data yang disimpan
      'username': username,
      'message': message,
      'file_url': fileUrl,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
