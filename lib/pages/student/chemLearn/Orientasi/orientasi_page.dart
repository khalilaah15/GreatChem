import 'package:flutter/material.dart';
import 'package:greatchem/pages/student/chemLearn/Orientasi/masalah1_page.dart';
import 'package:greatchem/pages/student/chemLearn/Orientasi/masalah2_page.dart';
import 'package:greatchem/pages/student/chemLearn/Orientasi/masalah3_page.dart';
import 'package:greatchem/pages/student/chemLearn/Orientasi/masalah4_page.dart';

class OrientasiPage extends StatelessWidget {
  const OrientasiPage({super.key});
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orientasi Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _navigateTo(context, const Masalah1Page()),
              child: const Text('Masalah 1'),
            ),
            ElevatedButton(
              onPressed: () => _navigateTo(context, const Masalah2Page()),
              child: const Text('Masalah 2'),
            ),
            ElevatedButton(
              onPressed: () => _navigateTo(context, const Masalah3Page()),
              child: const Text('Masalah 3'),
            ),
            ElevatedButton(
              onPressed: () => _navigateTo(context, const Masalah4Page()),
              child: const Text('Masalah 4'),
            ),
          ],
        ),
      ),
    );
  }
}
