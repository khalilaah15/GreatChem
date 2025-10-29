import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/models/chat_message.dart';
import 'package:greatchem/service/chat_kelompok_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRoomPage extends StatefulWidget {
  final ChatRoom room;
  final VoidCallback onFinished;
  const ChatRoomPage({Key? key, required this.room, required this.onFinished})
    : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final _chatService = ChatService();
  final _messageController = TextEditingController();
  final _currentUserId = Supabase.instance.client.auth.currentUser!.id;
  bool _hasSentFirstMessage = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    if (!_hasSentFirstMessage) {
      widget.onFinished();
      _hasSentFirstMessage = true;
    }

    await _chatService.sendMessage(roomId: widget.room.id, message: message);
    _messageController.clear();
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
        backgroundColor: const Color(0xFF4F200D),
      ),
      backgroundColor: const Color(0xFFB07C48),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            margin: EdgeInsets.all(10.r),
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFFF9EF96),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              shadows: [
                BoxShadow(
                  color: const Color(0x3F000000),
                  blurRadius: 4.r,
                  offset: const Offset(0, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Text(
              '1. Periksa kembali hasil diskusi\n2. Presentasikan hasil diskusi dengan teman sekelas\n3. Kirim hasil diskusi kelompok pada kolom diskusi kelas',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: const Color(0xFF6C432D),
                fontSize: 13.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.r),
            padding: EdgeInsets.all(16.r),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFFFF9A00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              shadows: [
                BoxShadow(
                  color: const Color(0x3F000000),
                  blurRadius: 4.r,
                  offset: const Offset(0, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Text(
              'Diskusi Kelompok',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.getMessagesStream(widget.room.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Mulai percakapan!"));
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(10.r),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == _currentUserId;
                    return _buildMessageBubble(msg, isMe);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFF9EF96) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomRight: isMe ? Radius.circular(4.r) : Radius.circular(16.r),
            bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(4.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                msg.senderName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            Text(msg.message, style: TextStyle(fontSize: 16.sp)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Ketik pesan...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            SizedBox(width: 8.w),
            IconButton.filled(
              icon: const Icon(Icons.send),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFED832F),
              ),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
