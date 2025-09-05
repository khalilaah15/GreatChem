import 'package:flutter/material.dart';
import 'package:greatchem/pages/auth/login_page.dart';
import 'package:greatchem/pages/auth/welcome_page.dart';
import 'package:greatchem/pages/student/home_page.dart';
import 'package:greatchem/pages/teacher/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<String?> _getUserRole() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;

    final response = await Supabase.instance.client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    if (response != null && response['role'] != null) {
      return response['role'] as String;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session =
            snapshot.data?.session ?? Supabase.instance.client.auth.currentSession;

        if (session == null) {
          // Tidak ada session → ke LoginPage
          return WelcomeScreen();
        }

        return FutureBuilder<String?>(
          future: _getUserRole(),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final role = roleSnapshot.data;

            if (role == "siswa") {
              return const SiswaPage();
            } else if (role == "guru") {
              return const GuruPage();
            } else {
              return WelcomeScreen();
            }
          },
        );
      },
    );
  }
}
