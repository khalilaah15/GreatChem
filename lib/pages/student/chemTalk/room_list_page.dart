// file: pages/room_list_page.dart
import 'package:flutter/material.dart';
import 'package:greatchem/models/chat_message.dart';
import 'package:greatchem/service/chat_kelompok_supabase_service.dart';
import 'chat_room_page.dart';

class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  final _chatService = ChatService();

  void _showCreateRoomDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Buat Room Diskusi Baru"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama Kelompok"),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: "Topik Diskusi"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(ctx),
            ),
            ElevatedButton(
              child: const Text("Buat"),
              onPressed: () async {
                if (nameController.text.trim().isEmpty) return;
                await _chatService.createRoom(
                  name: nameController.text.trim(),
                  description: descController.text.trim(),
                );
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diskusi Kelompok"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: _showCreateRoomDialog,
          ),
        ],
      ),
      body: StreamBuilder<List<ChatRoom>>(
        stream: _chatService.getRoomsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada diskusi. Buat yang pertama!"));
          }
          final rooms = snapshot.data!;
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.group)),
                title: Text(room.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  room.lastMessage ?? room.description ?? 'Belum ada pesan',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChatRoomPage(room: room)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}