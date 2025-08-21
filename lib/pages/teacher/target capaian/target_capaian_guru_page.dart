import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TargetCapaianGuruPage extends StatefulWidget {
  const TargetCapaianGuruPage({Key? key}) : super(key: key);

  @override
  State<TargetCapaianGuruPage> createState() => _TargetCapaianGuruPageState();
}

class _TargetCapaianGuruPageState extends State<TargetCapaianGuruPage> {
  final _supabase = Supabase.instance.client;

  bool _isLoading = true;
  List<Map<String, dynamic>> _students = [];
  String? _selectedStudentId;
  
  double _currentPercentage = 0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('id, name')
          .eq('role', 'siswa')
          .order('name', ascending: true);
      _students = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      _showErrorSnackBar('Gagal memuat daftar siswa.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchStudentPercentage(String studentId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('target_capaian')
          .eq('id', studentId)
          .single();
      
      // Nilai dari database bisa jadi null jika baru dibuat, default ke 0
      final percentage = response['target_capaian'] ?? 0;
      
      if (mounted) {
        setState(() {
          _currentPercentage = (percentage as int).toDouble();
        });
      }
    } catch (e) {
      _showErrorSnackBar('Gagal memuat data capaian siswa.');
    }
  }

  Future<void> _savePercentage() async {
    if (_selectedStudentId == null) {
      _showErrorSnackBar('Pilih siswa terlebih dahulu.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _supabase
        .from('profiles')
        .update({'target_capaian': _currentPercentage.toInt()})
        .eq('id', _selectedStudentId!);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Target capaian berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Gagal menyimpan data.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atur Target Capaian Siswa'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedStudentId,
                  hint: const Text('Pilih Siswa'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: _students.map<DropdownMenuItem<String>>((student) {
                    return DropdownMenuItem<String>(
                      value: student['id'] as String,
                      child: Text(student['name'] as String),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedStudentId = value);
                      _fetchStudentPercentage(value);
                    }
                  },
                ),
                if (_selectedStudentId != null) ...[
                  const SizedBox(height: 32),
                  Text(
                    'Atur Persentase Capaian:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${_currentPercentage.toInt()}%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Slider(
                    value: _currentPercentage,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${_currentPercentage.toInt()}%',
                    onChanged: (value) {
                      setState(() => _currentPercentage = value);
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _savePercentage,
                      icon: _isSaving
                          ? const SizedBox.shrink()
                          : const Icon(Icons.save),
                      label: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Simpan'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  )
                ],
              ],
            ),
    );
  }
}
