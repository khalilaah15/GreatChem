import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import screenutil
import 'package:greatchem/service/chat_kelas_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SesiTanyajawabPage extends StatefulWidget {
  const SesiTanyajawabPage({super.key});

  @override
  State<SesiTanyajawabPage> createState() => _SesiTanyajawabPageState();
}

class _SesiTanyajawabPageState extends State<SesiTanyajawabPage> {
  final service = ChatKelasSupabaseService();
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _currentUsername;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _loadUserName() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final profile =
          await Supabase.instance.client
              .from('profiles')
              .select('name')
              .eq('id', user.id)
              .single();
      if (mounted) {
        setState(() {
          _currentUsername = profile['name'];
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_currentUsername == null) return;

    final messageText = _msgController.text.trim();
    if (messageText.isNotEmpty) {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      await service.sendMessage(_currentUsername!, messageText, userId);
      _msgController.clear();
    }
  }

  Future<void> _sendFile() async {
    if (_currentUsername == null) return;
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path!);
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      await service.sendMessage(_currentUsername!, "", userId, file: file);
    }
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
          'Sesi Tanya Jawab',
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
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: service.getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(10.r), // Diubah
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final currentUserId =
                        Supabase.instance.client.auth.currentUser?.id;
                    final isMe = msg['user_id'] == currentUserId;

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

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isMe) {
    final bubbleRadius = BorderRadius.only(
      topLeft: Radius.circular(16.r), // Diubah
      topRight: Radius.circular(16.r), // Diubah
      bottomRight:
          isMe ? Radius.circular(4.r) : Radius.circular(16.r), // Diubah
      bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(4.r), // Diubah
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: ScreenUtil().screenWidth * 0.75, // Diubah
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 8.h,
        ), // Diubah
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w), // Diubah
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFFFDC7C) : Colors.white,
          borderRadius: bubbleRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 3.r, // Diubah
              offset: Offset(1.w, 1.h), // Diubah
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                msg['username'] ?? 'Tanpa Nama',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp, // Diubah
                  color: Theme.of(context).primaryColor,
                ),
              ),
            if ((msg['message'] as String?)?.isNotEmpty ?? false)
              Padding(
                padding: EdgeInsets.only(top: isMe ? 0 : 4.h), // Diubah
                child: Text(
                  msg['message'],
                  style: TextStyle(fontSize: 13.sp), // Diubah
                ),
              ),
            if (msg['file_url'] != null) _buildFileAttachment(msg['file_url']),
          ],
        ),
      ),
    );
  }

  Widget _buildFileAttachment(String url) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          await launchUrl(uri, mode: LaunchMode.inAppWebView);
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 8.h), // Diubah
        padding: EdgeInsets.all(8.r), // Diubah
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8.r), // Diubah
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.attach_file,
              color: Theme.of(context).primaryColor,
              size: 20.sp, // Diubah
            ),
            SizedBox(width: 8.w), // Diubah
            Text(
              "Lihat File Lampiran",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14.sp,
              ), // Diubah
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(8.r), // Diubah
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -1.h), // Diubah
              blurRadius: 3.r, // Diubah
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file_outlined),
              onPressed: _sendFile,
            ),
            Expanded(
              child: TextField(
                controller: _msgController,
                decoration: InputDecoration(
                  hintText: "Ketik pesan...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r), // Diubah
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w, // Diubah
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            SizedBox(width: 8.w), // Diubah
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
