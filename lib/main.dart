import 'package:flutter/material.dart';
// import 'package:flutter_tex/flutter_tex.dart';
import 'package:greatchem/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart'; // <-- penting

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await TeXRenderingServer.start();
  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://tkycaxymcknrssqiqywx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRreWNheHltY2tucnNzcWlxeXd4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4MjY5NjEsImV4cCI6MjA3MDQwMjk2MX0.sajf4EhCLupXlYu5UIeNHkYeAINkmOgrO6_881mMjvI',
  );

  // Inisialisasi FilePicker supaya gak kena LateInitializationError
  FilePicker.platform;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
