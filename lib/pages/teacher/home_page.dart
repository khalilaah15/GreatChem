import 'package:flutter/material.dart';
import 'package:greatchem/pages/auth/profile_page.dart';
import 'package:greatchem/pages/teacher/evaluasi/evaluasi_page.dart';
import 'package:greatchem/pages/teacher/hasil%20diskusi/hasil_diskusi_page.dart';
import 'package:greatchem/pages/teacher/hasil%20latihan/hasil_latihan_page.dart';
import 'package:greatchem/pages/teacher/target%20capaian/target_capaian_guru_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GuruPage extends StatefulWidget {
  const GuruPage({super.key});

  @override
  State<GuruPage> createState() => _GuruPageState();
}

class _GuruPageState extends State<GuruPage> {
  String? fullName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final response =
          await Supabase.instance.client
              .from('profiles')
              .select('name')
              .eq('id', user.id)
              .single();

      setState(() {
        fullName = response['name'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Guru"),
        actions: [
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                ),
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      body: Center(
        child:
            isLoading
                ? const CircularProgressIndicator()
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Selamat datang, ${fullName ?? 'User'} 👋",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HasilDiskusiPage(),
                          ),
                        );
                      },
                      child: const Text('Hasil Diskusi'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChemTryResultPage(),
                          ),
                        );
                      },
                      child: const Text('Hasil Latihan Soal'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EvaluasiPage(),
                          ),
                        );
                      },
                      child: const Text('Evaluasi'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TargetCapaianGuruPage(),
                          ),
                        );
                      },
                      child: const Text('Target Capaian'),
                    ),
                  ],
                ),
      ),
    );
  }
}
