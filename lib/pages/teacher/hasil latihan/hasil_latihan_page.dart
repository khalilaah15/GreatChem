import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChemTryResultPage extends StatefulWidget {
  const ChemTryResultPage({Key? key}) : super(key: key);

  @override
  State<ChemTryResultPage> createState() => _ChemTryResultPageState();
}

class _ChemTryResultPageState extends State<ChemTryResultPage> {
  final _supabase = Supabase.instance.client;
  final _feedbackController = TextEditingController();

  bool _isLoading = true;
  String? _selectedStudentId;
  List<Map<String, dynamic>> _students = [];

  bool _isResultLoading = false;
  Map<String, dynamic>? _submission;
  List<Map<String, dynamic>> _answers = [];

  // --- STATE BARU UNTUK TOMBOL ---
  bool _isSubmittingFeedback = false;
  bool _feedbackAlreadyExists = false;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
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
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  Future<void> _fetchStudentResults(String studentId) async {
    setState(() {
      _isResultLoading = true;
      _submission = null;
      _answers = [];
      _feedbackController.text = '';
      _feedbackAlreadyExists = false; // Reset state
    });

    try {
      final submissionResponse =
          await _supabase
              .from('chem_try_submissions')
              .select()
              .eq('student_id', studentId)
              .order('submitted_at', ascending: false)
              .limit(1)
              .maybeSingle();

      if (submissionResponse == null) {
        _showErrorSnackBar('Siswa ini belum mengerjakan ChemTry.');
        setState(() {
          _isResultLoading = false;
        });
        return;
      }

      _submission = submissionResponse;
      final existingFeedback = _submission?['teacher_feedback'];
      _feedbackController.text = existingFeedback ?? '';

      // --- PERUBAHAN DI SINI ---
      if (existingFeedback != null && existingFeedback.isNotEmpty) {
        _feedbackAlreadyExists = true;
      }

      final answersResponse = await _supabase
          .from('chem_try_answers')
          .select('*, question:chem_try_questions(*)')
          .eq('submission_id', _submission!['id']);

      _answers = List<Map<String, dynamic>>.from(answersResponse);
    } catch (e) {
      _showErrorSnackBar('Gagal memuat hasil pengerjaan siswa.');
    } finally {
      if (mounted)
        setState(() {
          _isResultLoading = false;
        });
    }
  }

  Future<void> _sendOrUpdateFeedback() async {
    if (_submission == null || _feedbackController.text.isEmpty) {
      _showErrorSnackBar('Feedback tidak boleh kosong.');
      return;
    }

    setState(() {
      _isSubmittingFeedback = true;
    });

    final submissionId = _submission!['id'];
    try {
      await _supabase
          .from('chem_try_submissions')
          .update({'teacher_feedback': _feedbackController.text})
          .eq('id', submissionId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Feedback berhasil ${_feedbackAlreadyExists ? 'diperbarui' : 'dikirim'}!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // --- PERUBAHAN DI SINI ---
      setState(() {
        _feedbackAlreadyExists = true;
      });
      FocusScope.of(context).unfocus();
    } catch (e) {
      _showErrorSnackBar('Gagal mengirim feedback.');
    } finally {
      if (mounted)
        setState(() {
          _isSubmittingFeedback = false;
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'Hasil ChemTry Siswa',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: const Color(0xFF6C432D),
      ),
      backgroundColor: const Color(0xFFDFCFB5),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    _buildStudentDropdown(),
                    const SizedBox(height: 20),
                    if (_isResultLoading)
                      const Center(child: CircularProgressIndicator()),
                    if (!_isResultLoading && _submission != null)
                      _buildResultDetails(),
                  ],
                ),
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
          _fetchStudentResults(value);
        }
      },
    );
  }

  Widget _buildResultDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Colors.blue.shade50,
          child: ListTile(
            title: const Text('Skor Siswa'),
            trailing: Text(
              _submission!['total_score'].toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Feedback untuk Siswa:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _feedbackController,
          maxLines: 4,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Tulis feedback di sini...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            // --- PERUBAHAN DI SINI ---
            onPressed: _isSubmittingFeedback ? null : _sendOrUpdateFeedback,
            icon: Icon(
              _feedbackAlreadyExists ? Icons.edit : Icons.send,
              color: Colors.white,
              size: 18.sp,
            ),
            label: Text(
              _isSubmittingFeedback
                  ? 'Mengirim...'
                  : _feedbackAlreadyExists
                  ? 'Perbarui Feedback'
                  : 'Kirim Feedback',
              style: TextStyle(color: Colors.white, fontSize: 13.sp),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor:
                  _feedbackAlreadyExists
                      ? Colors.amber.shade700
                      : Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Detail Jawaban:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ..._answers.map((answer) {
          final question = answer['question'];
          final isCorrect = answer['is_correct'] as bool;
          return Card(
            color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question['question_text'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jawaban Siswa: ${answer['selected_answer']}',
                    style: TextStyle(
                      color:
                          isCorrect
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                    ),
                  ),
                  if (!isCorrect)
                    Text(
                      'Jawaban Benar: ${question['correct_answer']}',
                      style: TextStyle(color: Colors.green.shade800),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
