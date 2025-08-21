import 'package:flutter/material.dart';
import 'package:greatchem/pages/teacher/hasil%20diskusi/list_diskusi_kelompok_page.dart';
import 'package:greatchem/pages/teacher/hasil%20diskusi/penilaian_sebaya_page.dart';
import 'package:greatchem/pages/teacher/hasil%20diskusi/sesi_presentasi_page.dart';
import 'package:greatchem/pages/teacher/hasil%20diskusi/sesi_tanyajawab_page.dart';

class HasilDiskusiPage extends StatelessWidget {
  const HasilDiskusiPage({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Diskusi')),
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _navigateTo(context, const SesiPresentasiPage()),
              child: const Text('Cek Diskusi Kelas Sesi Presentasi'),
            ),
            ElevatedButton(
              onPressed: () => _navigateTo(context, const SesiTanyajawabPage()),
              child: const Text('Cek Diskusi Kelas Sesi Tanya Jawab'),
            ),
            ElevatedButton(
              onPressed: () => _navigateTo(context, const ListDiskusiKelompokPage()),
              child: const Text('Cek Diskusi Kelompok'),
            ),
            ElevatedButton(
              onPressed: () => _navigateTo(context, const AssessmentResultPage()),
              child: const Text('Cek Penilaian Sebaya'),
            ),
          ],
        ),
      ),
    );
  }
}
