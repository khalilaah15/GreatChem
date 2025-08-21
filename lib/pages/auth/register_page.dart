import 'package:flutter/material.dart';
import 'package:greatchem/auth/auth_service.dart';
import 'package:greatchem/pages/auth/login_page.dart';
import 'package:greatchem/pages/auth/profile_page.dart';
import 'package:greatchem/pages/student/home_page.dart';
import 'package:greatchem/pages/teacher/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();

  // Controllers
  final _nameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _nisnNipController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String role = "siswa"; // default role

  Future<void> signUp() async {
    final name = _nameController.text.trim();
    final school = _schoolController.text.trim();
    final nisnNip = _nisnNipController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
        },
      );

      final user = response.user;

      if (user != null) {
        await Supabase.instance.client.from('profiles').insert({
          'id': user.id,
          'name': name,
          'school_name': school,
          'nisn_nip': nisnNip,
          'role': role,
        });

        if (mounted) {
          if (role == "siswa") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SiswaPage()),
            );
          } else if (role == "guru") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const GuruPage()),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: _schoolController,
              decoration: const InputDecoration(labelText: "Nama Sekolah"),
            ),
            TextField(
              controller: _nisnNipController,
              decoration: const InputDecoration(labelText: "NISN / NIP"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirm Password"),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: role,
              decoration: const InputDecoration(labelText: "Masuk Sebagai"),
              items: const [
                DropdownMenuItem(value: "siswa", child: Text("Siswa")),
                DropdownMenuItem(value: "guru", child: Text("Guru")),
              ],
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: signUp, child: const Text("Sign Up")),
            SizedBox(height: 15),
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
