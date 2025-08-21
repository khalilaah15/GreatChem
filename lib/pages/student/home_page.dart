import 'package:flutter/material.dart';
import 'package:greatchem/pages/auth/profile_page.dart';
import 'package:greatchem/pages/student/chemLearn/cptp_page.dart';
import 'package:greatchem/pages/student/chemTalk/room_list_page.dart';
import 'package:greatchem/pages/student/chemTrack/target_capaian_siswa.dart';
import 'package:greatchem/pages/student/chemTry/start_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SiswaPage extends StatefulWidget {
  const SiswaPage({super.key});

  @override
  State<SiswaPage> createState() => _SiswaPageState();
}

class _SiswaPageState extends State<SiswaPage> {
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
        title: const Text("Dashboard Siswa"),
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
                            builder: (context) => const CPTPPage(),
                          ),
                        );
                      },
                      child: const Text('ChemLearn'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StartPage(),
                          ),
                        );
                      },
                      child: const Text('ChemTry'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomListPage(),
                          ),
                        );
                      },
                      child: const Text('ChemTalk'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const TargetCapaianSiswaPage(),
                          ),
                        );
                      },
                      child: const Text('ChemTrack'),
                    ),
                  ],
                ),
      ),
    );
  }
}
