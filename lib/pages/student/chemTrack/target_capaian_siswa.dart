import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TargetCapaianSiswaPage extends StatefulWidget {
  const TargetCapaianSiswaPage({Key? key}) : super(key: key);

  @override
  State<TargetCapaianSiswaPage> createState() => _TargetCapaianSiswaPageState();
}

class _TargetCapaianSiswaPageState extends State<TargetCapaianSiswaPage> {
  final _supabase = Supabase.instance.client;
  int? _percentage;

  @override
  void initState() {
    super.initState();
    _fetchMyPercentage();
  }

  Future<void> _fetchMyPercentage() async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final response = await _supabase
          .from('profiles')
          .select('target_capaian')
          .eq('id', userId)
          .single();
      
      if (mounted) {
        setState(() {
          _percentage = response['target_capaian'] ?? 0;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memuat data capaian.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Target Capaian Belajar'),
      ),
      body: Center(
        child: _percentage == null
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Capaian Kamu Saat Ini',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: _percentage! / 100,
                                strokeWidth: 12,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                              Center(
                                child: Text(
                                  '$_percentage%',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Terus tingkatkan prestasimu dan tetap semangat!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
