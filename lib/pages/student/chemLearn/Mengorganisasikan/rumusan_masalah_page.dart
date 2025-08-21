import 'package:flutter/material.dart';
import 'package:greatchem/pages/student/chemLearn/Mengorganisasikan/menu_page.dart';

class RumusanMasalahPage extends StatefulWidget {
  const RumusanMasalahPage({super.key});

  @override
  State<RumusanMasalahPage> createState() => _RumusanMasalahPageState();
}

class _RumusanMasalahPageState extends State<RumusanMasalahPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MenuOrganisasiPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rumusan Masalah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Masukkan Rumusan Masalah:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tulis rumusan masalah di sini...',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _goToNextPage,
              child: const Text('Lanjut'),
            ),
          ],
        ),
      ),
    );
  }
}
