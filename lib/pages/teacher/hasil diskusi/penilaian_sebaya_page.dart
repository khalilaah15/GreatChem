import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
        final total = _results
            .map((r) => r['total_skor'] as int)
            .reduce((a, b) => a + b);
        _averageScore = total / _results.length;
      }
    } catch (e) {
      _showErrorSnackBar('Gagal memuat hasil penilaian.');
    } finally {
      if (mounted) {
        setState(() {
          _isResultLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'Penilaian Sejawat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: const Color(0xFF4F200D),
      ),
      backgroundColor: const Color(0xFFB07C48),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/bottom.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                            padding: EdgeInsets.all(16.r),
                            child: Column(
                              children: [
                                _buildStudentDropdown(),
                                SizedBox(height: 20.h),
                                if (_isResultLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                if (!_isResultLoading &&
                                    _selectedStudentId != null)
                                  _buildResultsTable(),
                              ],
                            ),
                          ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedStudentId,
      hint: const Text('Pilih siswa untuk melihat hasil'),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF8F6E9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
      items:
          _students.map((student) {
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
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: const Text(
            'Belum ada data penilaian untuk siswa ini.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: [
        Card(
          color: const Color(0xFFFFDC7C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rata-rata Skor Total:',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _averageScore?.toStringAsFixed(2) ?? '0.0',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: DataTable(
              columnSpacing: 50.w,
              headingRowHeight: 40.h,
              dataRowHeight:
                  38.h, // Ganti dari dataRowMinHeight ke dataRowHeight
              headingRowColor: MaterialStateProperty.all(
                const Color(0xFFFFD93D), // header coklat
              ),
              dataRowColor: MaterialStateProperty.all(
                const Color(0xFFF8F6E9), // isi cream
              ),
              border: TableBorder.all(
                color: const Color(
                  0xFFB07C48,
                ), // coklat tua untuk garis pembatas
                width: 1.w,
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'Nama Penilai',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF5A3D2B),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Total Skor',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF5A3D2B),
                    ),
                  ),
                  numeric: true,
                ),
              ],
              rows:
                  _results.map((result) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            result['nama_penilai'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF5A3D2B),
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            result['total_skor'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF5A3D2B),
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
