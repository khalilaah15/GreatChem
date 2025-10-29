import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/models/chat_message.dart';
import 'package:greatchem/pages/student/chemTrack/target_capaian_siswa.dart';
import 'package:greatchem/service/chat_kelompok_supabase_service.dart';
import 'chat_room_page.dart';

class RoomListPage extends StatefulWidget {
  final VoidCallback onFinished;
  const RoomListPage({Key? key, required this.onFinished}) : super(key: key);

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
          title: Text(
            "Buat Room Diskusi Baru",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF6C432D),
              fontSize: 20.sp,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w800,
              height: 1.12,
            ),
          ),
          backgroundColor: const Color(0xFFFDFCEA),
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
              child: const Text("Batal", style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.pop(ctx),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED832F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: const Text(
                "Buat",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'ChemTalk',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TargetCapaianSiswaPage(),
                ),
              );
            },
          ),
          SizedBox(width: 5.w),
        ],
        backgroundColor: const Color(0xFF4F200D),
      ),
      backgroundColor: const Color(0xFFDFCFB5),
      body: StreamBuilder<List<ChatRoom>>(
        stream: _chatService.getRoomsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Belum ada diskusi. Buat yang pertama!"),
            );
          }
          final rooms = snapshot.data!;
          return ListView.separated(
            padding: EdgeInsets.all(10.r),
            itemCount: rooms.length,
            separatorBuilder:
                (context, index) => Divider(
                  color: Colors.white,
                  thickness: 1,
                  indent: 72.w,
                  endIndent: 25.w,
                  height: 0,
                ),
            itemBuilder: (context, index) {
              final room = rooms[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 24.r,
                  backgroundColor: const Color(0xFFED832F),
                  child: Icon(Icons.group, color: Colors.white, size: 28.r),
                ),
                title: Text(
                  room.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  room.lastMessage ?? room.description ?? 'Belum ada pesan',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ChatRoomPage(
                            room: room,
                            onFinished: widget.onFinished,
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFED832F),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showCreateRoomDialog();
        },
      ),
    );
  }
}
