import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/service/tugas_supabase_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MengembangkanPage extends StatefulWidget {
  const MengembangkanPage({super.key});

  @override
  State<MengembangkanPage> createState() => _MengembangkanPageState();
}

class _MengembangkanPageState extends State<MengembangkanPage> {
  final service = TugasSupabaseService();
  List<Map<String, dynamic>> _tugasList = [];

  @override
  void initState() {
    super.initState();
    _loadTugas();
  }

  Future<void> _loadTugas() async {
    final data = await service.getTugas();
    setState(() => _tugasList = data);
  }

  void _showUploadDialog() {
    final namaController = TextEditingController();
    File? pickedFile;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                'Kumpulkan Hasil Diskusimu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF6C432D),
                  fontSize: 16.sp,
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
                    controller: namaController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Tulis Nama Kelompok',
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C432D),
                    ),
                    icon: const Icon(Icons.attach_file, color: Colors.white),
                    label: Text(
                      pickedFile == null ? "Pilih File" : "File dipilih",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        withData: true,
                      );

                      if (result != null && result.files.single.path != null) {
                        setStateDialog(() {
                          pickedFile = File(result.files.single.path!);
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Batal",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED832F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  onPressed: () async {
                    if (namaController.text.isEmpty || pickedFile == null) {
                      return;
                    }

                    await service.uploadTugas(namaController.text, pickedFile!);
                    Navigator.pop(context);
                    _loadTugas();
                  },
                  child: const Text(
                    "Kirim",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openFile(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // fallback ke in-app webview
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
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
          'Mengembangkan dan Menyajikan Hasil Karya',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: const Color(0xFF6C432D),
      ),
      backgroundColor: const Color(0xFFDFCFB5),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.all(16.r),
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFFFFDC7C),
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
                'Bersama kelompokmu sajikan hasil diskusi secara kolaboratif melalui kegiatan presentasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF6C432D),
                  fontSize: 14.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            buildStyledButton(
              icon: Icons.send,
              iconData: Icons.document_scanner_rounded,
              text: 'Upload Tugas',
              onTap: _showUploadDialog,
            ),
            Expanded(
              child:
                  _tugasList.isEmpty
                      ? const Center(child: Text("Belum ada tugas dikumpulkan"))
                      : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          padding: EdgeInsets.all(15.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: const Color(0xFFD6C7B0),
                              width: 1.w,
                            ),
                          ),
                          child: DataTable(
                            columnSpacing: 50.w,
                            headingRowHeight: 48.h,
                            dataRowHeight: 56.h,
                            headingRowColor: MaterialStateProperty.all(
                              const Color(0xFFC49C75),
                            ),
                            dataRowColor: MaterialStateProperty.all(
                              const Color(0xFFF8F6E9),
                            ),
                            border: TableBorder.all(
                              color: const Color(0xFFDFCFB5),
                              width: 1.w,
                            ),
                            columns: const [
                              DataColumn(
                                label: Text(
                                  "Kelompok",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  textAlign: TextAlign.center,
                                  "Berkas Tugas",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                            rows:
                                _tugasList.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          textAlign: TextAlign.center,
                                          item['nama_kelompok'] ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF5A3D2B),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        IconButton(
                                          icon: Icon(
                                            Icons.picture_as_pdf,
                                            color: Colors.red,
                                            size: 28.sp,
                                          ),
                                          onPressed:
                                              () => _openFile(item['file_url']),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
            ),
            const Spacer(),
            Image.asset('assets/images/bottom.png', fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }

  Widget buildStyledButton({
    required IconData iconData,
    required String text,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 24.w),
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: const Color(0xFFC2A180),
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: const Color(0xFF6E4B34), width: 1.w),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: const BoxDecoration(
                color: Color(0xFF4a3826),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: const Color(0xFFfdd835),
                size: 28.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Icon(icon, color: Colors.white, size: 30.sp),
            ),
          ],
        ),
      ),
    );
  }
}
