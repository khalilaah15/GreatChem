import 'package:flutter/material.dart';
import 'package:greatchem/auth/auth_service.dart';
import 'package:greatchem/pages/auth/register_page.dart';
import 'package:greatchem/pages/student/home_page.dart';
import 'package:greatchem/pages/teacher/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response = await authService.signInWithEmailPassword(
        email,
        password,
      );
      final user = response.user;

      if (user != null) {
        // Ambil role dari tabel profiles
        final profile =
            await Supabase.instance.client
                .from('profiles')
                .select('role')
                .eq('id', user.id)
                .maybeSingle();

        if (profile != null) {
          final role = profile['role'];
          if (role == 'guru') {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const GuruPage()),
              );
            }
          } else if (role == 'siswa') {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SiswaPage()),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Role tidak dikenal")),
              );
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login gagal: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Login")),
            SizedBox(height: 15),
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  ),
              child: const Text('signup'),
            ),
          ],
        ),
      ),
    );
  }
}
