import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_message.dart';

class ChatService {
  final _client = Supabase.instance.client;

  Future<void> createRoom({required String name, String? description}) async {
    await _client.rpc(
      'create_room',
      params: {'name': name, 'description': description},
    );
  }

  Future<void> sendMessage({
    required String roomId,
    required String message,
  }) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('chat_messages').insert({
      'room_id': roomId,
      'sender_id': userId,
      'message': message,
    });
  }

  Stream<List<ChatRoom>> getRoomsStream() {
    return _client
        .from('chat_rooms')
        .stream(primaryKey: ['id'])
        .order('last_message_at', ascending: false)
        .map((listOfMaps) => listOfMaps.map(ChatRoom.fromMap).toList());
  }

  Stream<List<ChatMessage>> getMessagesStream(String roomId) {
    return _client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at', ascending: false)
        .map((listOfMaps) {
          return _client
              .from('chat_messages')
              .select('*, profiles(name)')
              .eq('room_id', roomId)
              .order('created_at', ascending: false);
        })
        .asyncMap((futureResponse) async {
          final response = await futureResponse;
          return (response as List)
              .map((item) => ChatMessage.fromMap(item as Map<String, dynamic>))
              .toList();
        });
  }
}
