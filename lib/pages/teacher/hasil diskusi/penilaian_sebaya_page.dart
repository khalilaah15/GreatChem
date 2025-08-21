import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssessmentResultPage extends StatefulWidget {
  const AssessmentResultPage({Key? key}) : super(key: key);

  @override
  State<AssessmentResultPage> createState() => _AssessmentResultPageState();
}

class _AssessmentResultPageState extends State<AssessmentResultPage> {
  final _supabase = Supabase.instance.client;
  
  bool _isLoading = true;
  String? _selectedStudentId;
  List<Map<String, dynamic>> _students = [];
  
  bool _isResultLoading = false;
  List<Map<String, dynamic>> _results = [];
  double? _averageScore;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  // Mengambil daftar semua siswa untuk ditampilkan di dropdown
  Future<void> _fetchStudents() async {
    try {
      final studentsResponse = await _supabase
          .from('profiles')
          .select('id, name')
          .eq('role', 'siswa')
          .order('name', ascending: true);
      _students = List<Map<String, dynamic>>.from(studentsResponse);
    } catch (e) {
      _showErrorSnackBar('Gagal memuat daftar siswa.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Mengambil hasil penilaian untuk siswa yang dipilih menggunakan RPC
  Future<void> _fetchResults(String studentId) async {
    setState(() {
      _isResultLoading = true;
      _results = [];
      _averageScore = null;
    });

    try {
      final response = await _supabase.rpc(
        'get_penilaian_results',
        params: {'student_id': studentId},
      );
      
      _results = List<Map<String, dynamic>>.from(response);

      if (_results.isNotEmpty) {
        final total = _results.map((r) => r['total_skor'] as int).reduce((a, b) => a + b);
        _averageScore = total / _results.length;
      }

    } catch (e) {
      _showErrorSnackBar('Gagal memuat hasil penilaian.');
    } finally {
      setState(() {
        _isResultLoading = false;
      });
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
        title: const Text('Hasil Penilaian Siswa'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildStudentDropdown(),
                const SizedBox(height: 20),
                if (_isResultLoading)
                  const Center(child: CircularProgressIndicator()),
                if (!_isResultLoading && _selectedStudentId != null)
                  _buildResultsTable(),
              ],
            ),
    );
  }

  // Widget untuk dropdown memilih siswa
  Widget _buildStudentDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedStudentId,
      hint: const Text('Pilih siswa untuk melihat hasil'),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: _students.map((student) {
        return DropdownMenuItem<String>(
          value: student['id'],
          child: Text(student['name']),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedStudentId = value;
          });
          _fetchResults(value);
        }
      },
    );
  }

  // Widget untuk menampilkan tabel hasil atau pesan jika data kosong
  Widget _buildResultsTable() {
    if (_results.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Belum ada data penilaian untuk siswa ini.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: [
        Card(
          color: Theme.of(context).primaryColorLight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Rata-rata Skor Total:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  _averageScore?.toStringAsFixed(2) ?? '0.0',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8)
            ),
            headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
            columns: const [
              DataColumn(label: Text('Nama Penilai', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Total Skor', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
            ],
            rows: _results.map((result) {
              return DataRow(cells: [
                DataCell(Text(result['nama_penilai'].toString())),
                DataCell(Text(result['total_skor'].toString())),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
