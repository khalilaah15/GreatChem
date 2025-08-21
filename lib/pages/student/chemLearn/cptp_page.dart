import 'package:flutter/material.dart';
import 'package:greatchem/pages/student/chemLearn/jelajahi_page.dart';

class CPTPPage extends StatelessWidget {
  const CPTPPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CP dan TP")),
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JelajahiPage()),
              );
            },
            child: const Text('Selanjutnya'),
          ),
        ),
      ),
    );
  }
}
