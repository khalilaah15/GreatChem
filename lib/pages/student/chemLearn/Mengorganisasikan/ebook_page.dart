import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class EbookPage extends StatefulWidget {
  const EbookPage({super.key});

  @override
  State<EbookPage> createState() => _EbookPageState();
}

class _EbookPageState extends State<EbookPage> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    fromAsset('assets/ebook/ebook.pdf', 'ebook.pdf').then((f) {
      setState(() {
        localPath = f.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$filename");
    final data = await rootBundle.load(asset);
    final bytes = data.buffer.asUint8List();
    await file.writeAsBytes(bytes, flush: true);
    return file;
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
          'E-Book',
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
      body:
      // localPath != null
      //     ? PDFView(filePath: localPath!)
      //     : const Center(child: CircularProgressIndicator()),
      SfPdfViewer.asset('assets/ebook/ebook.pdf'),
    );
  }
}
