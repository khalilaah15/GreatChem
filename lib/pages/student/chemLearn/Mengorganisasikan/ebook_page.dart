import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
      appBar: AppBar(title: const Text("E-Book")),
      body: localPath != null
          ? PDFView(filePath: localPath!)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
