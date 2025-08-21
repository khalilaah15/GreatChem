import 'package:flutter/material.dart';
import 'package:greatchem/pages/student/chemTry/chemtry_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ChemTry")),
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChemTryPage()),
              );
            },
            child: const Text('Go to Next Page'),
          ),
        ),
      ),
    );
  }
}
