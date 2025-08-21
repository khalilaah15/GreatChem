class ChatRoom {
  final String id;
  final String name;
  final String? description;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  ChatRoom({
    required this.id,
    required this.name,
    this.description,
    this.lastMessage,
    this.lastMessageAt,
  });

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      lastMessage: map['last_message'],
      lastMessageAt:
          map['last_message_at'] != null
              ? DateTime.parse(map['last_message_at'])
              : null,
    );
  }
}

class ChatMessage {
  final String id;
  final String message;
  final String senderId;
  final String senderName;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.message,
    required this.senderId,
    required this.senderName,
    required this.createdAt,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      message: map['message'],
      senderId: map['sender_id'],
      senderName: map['profiles']?['name'] ?? 'Tanpa Nama',
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
