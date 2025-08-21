import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EvaluasiPage extends StatelessWidget {
  const EvaluasiPage({super.key});

  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Tidak bisa membuka link: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Evaluasi")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                _openLink(
                  "https://drive.google.com/drive/folders/1X1xnYnn2uBD4Jjg-swmZR6XfbTEtXXAJ?usp=drive_link",
                );
              },
              child: const Text('Unduh Form Evaluasi'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _openLink(
                  "https://drive.google.com/drive/folders/1lRiVA2hE8TVDrUvkj5ITlYUL3Ds2VQI3?usp=drive_link",
                );
              },
              child: const Text('Unggah Form Evaluasi'),
            ),
          ],
        ),
      ),
    );
  }
}
