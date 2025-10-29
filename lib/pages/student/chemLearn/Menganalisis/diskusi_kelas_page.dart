import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:greatchem/service/chat_kelas_supabase_service.dart';
import 'package:greatchem/pages/student/chemLearn/Menganalisis/penilaian_sebaya_page.dart';

class DiskusiKelasPage extends StatefulWidget {
  final VoidCallback onFinished;
  const DiskusiKelasPage({Key? key, required this.onFinished})
    : super(key: key);

  @override
  State<DiskusiKelasPage> createState() => _DiskusiKelasPageState();
}

class _DiskusiKelasPageState extends State<DiskusiKelasPage> {
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

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
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
          'Kajian Reaksi',
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
                  builder: (context) => PeerAssessmentPage(onFinished: () {}),
                ),
              );
            },
          ),
          SizedBox(width: 5.w),
        ],

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
              '1. Berikan tanggapan atau masukkan dari hasil presentasi kelompok lain\n2. Tanggapan atau masukkan bisa berupa kesimpulan yang diperoleh.',
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
                  padding: EdgeInsets.all(10.r),
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
      topLeft: Radius.circular(16.r),
      topRight: Radius.circular(16.r),
      bottomRight: isMe ? Radius.circular(4.r) : Radius.circular(16.r),
      bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(4.r),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFF9EF96) : Colors.white,
          borderRadius: bubbleRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 3.r,
              offset: const Offset(1, 1),
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
                  fontSize: 13.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            if ((msg['message'] as String?)?.isNotEmpty ?? false)
              Padding(
                padding: EdgeInsets.only(top: isMe ? 0 : 4.h),
                child: Text(msg['message'], style: TextStyle(fontSize: 13.sp)),
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
        margin: EdgeInsets.only(top: 8.h),
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.attach_file,
              color: Theme.of(context).primaryColor,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            const Text(
              "Lihat File Lampiran",
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -1),
              blurRadius: 3.r,
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
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
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton.filled(
                  icon: const Icon(Icons.send),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9A00),
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
            if (_currentUsername != null)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9A00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    onPressed: () {
                      _navigateTo(
                        context,
                        PeerAssessmentPage(onFinished: widget.onFinished),
                      );
                    },
                    child: Text(
                      "Mulai Penilaian Teman Sebaya",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
