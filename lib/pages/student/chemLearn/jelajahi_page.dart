import 'package:flutter/material.dart';
import 'package:greatchem/pages/student/chemLearn/Membimbing/membimbing_page.dart';
import 'package:greatchem/pages/student/chemLearn/Menganalisis/diskusi_kelas_page.dart';
import 'package:greatchem/pages/student/chemLearn/Mengembangkan/mengembangkan_page.dart';
import 'package:greatchem/pages/student/chemLearn/Mengorganisasikan/rumusan_masalah_page.dart';
import 'package:greatchem/pages/student/chemLearn/Orientasi/orientasi_page.dart';

class JelajahiPage extends StatelessWidget {
  const JelajahiPage({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mari Jelajahi Dunia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _navigateTo(context, const OrientasiPage()),
              child: const Text('Orientasi Siswa pada Masalah'),
            ),
            ElevatedButton(
              onPressed: () => _navigateTo(context, const RumusanMasalahPage()),
              child: const Text('Mengorganisasikan Siswa untuk Belajar'),
            ),
            ElevatedButton(
              onPressed: () => _navigateTo(context, const MembimbingPage()),
              child: const Text('Membimbing Penyelidikan Individual maupun Kelompok'),
            ),
            ElevatedButton(
              onPressed: () => _navigateTo(context, const MengembangkanPage()),
              child: const Text('Mengembangkan dan Menyajikan Hasil Karya'),
            ),
            ElevatedButton(
              onPressed: () => _navigateTo(context, const DiskusiKelasPage()),
              child: const Text('Menganalisis & Mengevaluasi Proses Pemecahan Masalah'),
            ),
          ],
        ),
      ),
    );
  }
}
