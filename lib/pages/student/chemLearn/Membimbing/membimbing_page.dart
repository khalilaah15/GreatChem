import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MembimbingPage extends StatelessWidget {
  const MembimbingPage({super.key});
  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Tidak bisa membuka link: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Membimbing Page')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('G-LAB')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _openLink(
                  "https://drive.google.com/file/d/1u8_Aut2SX_ncPhr1dNDEMEVsxoPdL5Cx/view",
                );
              },
              child: const Text('Unduh Laporan Hasil Praktikum'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _openLink(
                  "https://drive.google.com/drive/folders/1reNWXvtB3QZifO3lr-Dj9DOb-YlNGRfK?usp=drive_link",
                );
              },
              child: const Text('Pengumpulan Laporan Hasil Praktikum'),
            ),
          ],
        ),
      ),
    );
  }
}
