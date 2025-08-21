import 'package:flutter/material.dart';
import 'package:greatchem/pages/student/chemLearn/Mengorganisasikan/artificial_intelligence_page.dart';
import 'package:greatchem/pages/student/chemLearn/Mengorganisasikan/ebook_page.dart';

class MenuOrganisasiPage extends StatelessWidget {
  const MenuOrganisasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    void _goToNextPage() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ArtificialIntelligencePage(),
        ),
      );
    }

    void _goToNextSecondPage() {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const EbookPage()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Menu Organisasi')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _goToNextPage, child: const Text('AI')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _goToNextSecondPage,
              child: const Text('E-Book'),
            ),
          ],
        ),
      ),
    );
  }
}
