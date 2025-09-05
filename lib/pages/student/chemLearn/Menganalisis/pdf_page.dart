import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatelessWidget {
  // Terima URL dari halaman sebelumnya
  final String url;

  const PdfViewerPage({super.key, required this.url});

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
          'Dokumen',
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
      body: SfPdfViewer.network(
        url,
        // Tampilkan loading saat PDF sedang diunduh
        onDocumentLoadFailed: (details) {
          // Jika gagal, tampilkan pesan error di tengah layar
          print("Error saat memuat PDF: ${details.description}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memuat dokumen: ${details.error}')),
          );
        },
      ),
    );
  }
}
