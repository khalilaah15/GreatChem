import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/service/tugas_supabase_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SesiPresentasiPage extends StatefulWidget {
  const SesiPresentasiPage({super.key});

  @override
  State<SesiPresentasiPage> createState() => _SesiPresentasiPageState();
}

class _SesiPresentasiPageState extends State<SesiPresentasiPage> {
  final service = TugasSupabaseService();
  List<Map<String, dynamic>> _tugasList = [];
  bool _isLoading = true; // Tambahkan state untuk loading

  @override
  void initState() {
    super.initState();
    _loadTugas();
  }

  Future<void> _loadTugas() async {
    try {
      final data = await service.getTugas();
      if (mounted) {
        setState(() {
          _tugasList = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: ${e.toString()}')),
        );
      }
    }
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
          'Sesi Presentasi',
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
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/bottom.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      _tugasList.isEmpty
                          ? const Center(
                            child: Text("Belum ada tugas dikumpulkan"),
                          )
                          : Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.r),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: const Color(0xFFD6C7B0),
                                      width: 1.w,
                                    ),
                                  ),
                                  // ClipRRect ditambahkan untuk memastikan konten di dalamnya (DataTable) mengikuti bentuk radius
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: DataTable(
                                      columnSpacing: 50.w,
                                      headingRowHeight: 48.h,
                                      dataRowMinHeight: 56.h,
                                      dataRowMaxHeight: 60.h,
                                      headingRowColor:
                                          MaterialStateProperty.all(
                                            const Color(0xFFFFD93D),
                                          ),
                                      dataRowColor: MaterialStateProperty.all(
                                        const Color(0xFFF8F6E9),
                                      ),
                                      border: TableBorder.all(
                                        color: const Color(0xFFB07C48),
                                        width: 1.w,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Text(
                                            "Kelompok",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF5A3D2B),
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            "Berkas Tugas",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF5A3D2B),
                                              fontSize: 16.sp,
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
                                                    item['nama_kelompok'] ?? '',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                        0xFF5A3D2B,
                                                      ),
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.picture_as_pdf,
                                                        color: Colors.red,
                                                        size: 28.sp,
                                                      ),
                                                      onPressed:
                                                          () => _openFile(
                                                            item['file_url'],
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
