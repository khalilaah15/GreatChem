import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/pages/student/chemTry/chemtry_page.dart';
import 'package:greatchem/pages/student/chemTry/start_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeerAssessmentPage extends StatefulWidget {
  final VoidCallback onFinished;
  const PeerAssessmentPage({Key? key, required this.onFinished})
    : super(key: key);

  @override
  State<PeerAssessmentPage> createState() => _PeerAssessmentPageState();
}

class _PeerAssessmentPageState extends State<PeerAssessmentPage> {
  final _supabase = Supabase.instance.client;
  bool _hasSubmittedOnce = false;

  bool _isLoading = true;
  String? _selectedStudentId;
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _questions = [];
  final Map<int, double> _scores = {};
  bool _hasAlreadyAssessed = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  // Mengambil data awal: daftar siswa dan daftar pertanyaan
  Future<void> _fetchInitialData() async {
    try {
      final userId = _supabase.auth.currentUser!.id;

      // Ambil daftar siswa lain
      final studentsResponse = await _supabase
          .from('profiles')
          .select('id, name')
          .eq('role', 'siswa')
          .neq('id', userId);
      _students = List<Map<String, dynamic>>.from(studentsResponse);

      // Ambil daftar pertanyaan
      final questionsResponse = await _supabase
          .from('pertanyaan_penilaian')
          .select('id, teks_pertanyaan')
          .order('urutan', ascending: true);
      _questions = List<Map<String, dynamic>>.from(questionsResponse);
    } catch (e) {
      _showErrorSnackBar('Gagal memuat data. Coba lagi.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkAssessmentStatus(String assessedUserId) async {
    setState(() {
      _hasAlreadyAssessed = true;
    });
    try {
      final userId = _supabase.auth.currentUser!.id;
      final response = await _supabase
          .from('penilaian_sebaya')
          .select('id')
          .eq('penilai_id', userId)
          .eq('dinilai_id', assessedUserId)
          .limit(1);

      setState(() {
        _hasAlreadyAssessed = (response as List).isNotEmpty;
      });
    } catch (e) {
      _showErrorSnackBar('Gagal memeriksa status penilaian.');
    }
  }

  // Kirim data penilaian ke Supabase
  Future<void> _submitAssessment() async {
    if (_scores.length != _questions.length) {
      _showErrorSnackBar('Harap isi semua pertanyaan terlebih dahulu.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final userId = _supabase.auth.currentUser!.id;
      final totalScore = _scores.values.reduce((a, b) => a + b).toInt();

      final scoresForJson = _scores.map(
        (key, value) => MapEntry(key.toString(), value.toInt()),
      );

      await _supabase.from('penilaian_sebaya').insert({
        'penilai_id': userId,
        'dinilai_id': _selectedStudentId!,
        'skor': scoresForJson,
        'total_skor': totalScore,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Penilaian berhasil dikirim!'),
          backgroundColor: Colors.green,
        ),
      );

      if (!_hasSubmittedOnce) {
        widget.onFinished();
        _hasSubmittedOnce = true;
      }

      setState(() {
        _selectedStudentId = null;
        _scores.clear();
        _hasAlreadyAssessed = false;
      });
    } catch (e) {
      _showErrorSnackBar(
        'Gagal mengirim penilaian. Anda mungkin sudah pernah menilai siswa ini.',
      );
    } finally {
      setState(() => _isSubmitting = false);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'Penilaian Teman Sebaya',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => StartPage(onFinished: () {}),
                ),
              );
            },
          ),
          SizedBox(width: 5.w),
        ],
        backgroundColor: const Color(0xFF4F200D),
      ),
      backgroundColor: const Color(0xFFB07C48),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              margin: EdgeInsets.all(16.r),
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFFF9EF96),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0x3F000000),
                    blurRadius: 4.r,
                    offset: const Offset(0, 0),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Text(
                'Kriteria Penilaian: \n4: Selalu (apabila selalu sesuai pernyataan) \n3: Sering (apabila sering sesuai pernyataan dan kadang-kadang tidak) \n2: Kadang-kadang (apabila kadang-kadang dan sering tidak melakukan) \n1: Tidak Pernah (apabila tidak pernah melakukan)',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color(0xFF6C432D),
                  fontSize: 14.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      _buildStudentDropdown(),
                      SizedBox(height: 20.h),
                      if (_selectedStudentId != null) _buildAssessmentForm(),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  // Widget untuk dropdown memilih siswa
  Widget _buildStudentDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedStudentId,
      hint: const Text('Pilih teman yang akan dinilai'),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
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
            _scores.clear();
          });
          _checkAssessmentStatus(value);
        }
      },
    );
  }

  Widget _buildAssessmentForm() {
    if (_hasAlreadyAssessed) {
      return Card(
        color: Colors.amber.shade100,
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Text(
            'Anda sudah pernah menilai siswa ini.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Berikan penilaian (1-5) untuk setiap pertanyaan:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16.h),
        ..._questions.asMap().entries.map((entry) {
          int index = entry.key;
          var question = entry.value;
          int questionId = question['id'];
          return _buildQuestionSlider(
            index + 1,
            question['teks_pertanyaan'],
            questionId,
          );
        }),
        SizedBox(height: 24.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitAssessment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9A00),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child:
                _isSubmitting
                    ? SizedBox(
                      height: 24.r,
                      width: 24.r,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                    : Text(
                      'Kirim Penilaian',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  // Widget untuk satu pertanyaan dan slider-nya
  Widget _buildQuestionSlider(int number, String questionText, int questionId) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      color: const Color(0xFFFDFCEA),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$number. $questionText',
              style: TextStyle(
                color: const Color(0xFF6C432D),
                fontSize: 16.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  '1',
                  style: TextStyle(
                    color: const Color(0xFF6C432D),
                    fontSize: 16.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _scores[questionId] ?? 1.0,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: (_scores[questionId] ?? 1.0).round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _scores[questionId] = value;
                      });
                    },
                  ),
                ),
                Text(
                  '5',
                  style: TextStyle(
                    color: const Color(0xFF6C432D),
                    fontSize: 16.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
