import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/pages/student/home_page.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/blocks/leaf/paragraph.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChemTryPage extends StatefulWidget {
  final VoidCallback onFinished;
  const ChemTryPage({Key? key, required this.onFinished}) : super(key: key);

  @override
  State<ChemTryPage> createState() => _ChemTryPageState();
}

class _ChemTryPageState extends State<ChemTryPage> {
  final _supabase = Supabase.instance.client;

  bool _isLoading = true;
  List<Map<String, dynamic>> _questions = [];
  final Map<int, String> _selectedAnswers = {};

  bool _isQuizFinished = false;
  int _totalScore = 0;
  Map<String, dynamic>? _submissionData;

  @override
  void initState() {
    super.initState();
    _loadUserQuizState();
  }

  Future<void> _loadUserQuizState() async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final submissionResponse =
          await _supabase
              .from('chem_try_submissions')
              .select()
              .eq('student_id', userId)
              .order('submitted_at', ascending: false)
              .limit(1)
              .maybeSingle();

      if (submissionResponse != null) {
        await _fetchResults(submissionResponse);
      } else {
        await _fetchQuestions();
      }
    } catch (e) {
      _showErrorSnackBar('Gagal memuat data ChemTry. Coba lagi.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchResults(Map<String, dynamic> submission) async {
    _submissionData = submission;
    _totalScore = submission['total_score'];
    final questionsResponse = await _supabase
        .from('chem_try_questions')
        .select('*')
        .order('question_order', ascending: true);
    _questions = List<Map<String, dynamic>>.from(questionsResponse);
    final answersResponse = await _supabase
        .from('chem_try_answers')
        .select('question_id, selected_answer')
        .eq('submission_id', submission['id']);

    for (var answer in answersResponse) {
      _selectedAnswers[answer['question_id']] = answer['selected_answer'];
    }

    setState(() {
      _isQuizFinished = true;
    });
  }

  Future<void> _fetchQuestions() async {
    final response = await _supabase
        .from('chem_try_questions')
        .select()
        .order('question_order', ascending: true);
    _questions = List<Map<String, dynamic>>.from(response);
  }

  Future<void> _submitQuiz() async {
    if (_selectedAnswers.length != _questions.length) {
      _showErrorSnackBar('Harap jawab semua pertanyaan.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      int currentScore = 0;
      List<Map<String, dynamic>> answerDetails = [];

      for (var question in _questions) {
        final questionId = question['id'];
        final correctAnswer = question['correct_answer'];
        final selectedAnswer = _selectedAnswers[questionId];
        final isCorrect = selectedAnswer == correctAnswer;

        if (isCorrect) {
          currentScore += (question['point_value'] as int);
        }

        answerDetails.add({
          'question_id': questionId,
          'selected_answer': selectedAnswer,
          'is_correct': isCorrect,
        });
      }

      final submissionResponse =
          await _supabase
              .from('chem_try_submissions')
              .insert({
                'student_id': _supabase.auth.currentUser!.id,
                'total_score': currentScore,
              })
              .select()
              .single();

      final submissionId = submissionResponse['id'];

      for (var answer in answerDetails) {
        answer['submission_id'] = submissionId;
      }
      await _supabase.from('chem_try_answers').insert(answerDetails);
      widget.onFinished();

      setState(() {
        _totalScore = currentScore;
        _isQuizFinished = true;
        _submissionData = submissionResponse;
      });
    } catch (e) {
      _showErrorSnackBar('Terjadi kesalahan saat mengirim jawaban.');
    } finally {
      setState(() {
        _isLoading = false;
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SiswaPage()),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          'ChemTry',
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
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _isQuizFinished
              ? _buildResultView()
              : _buildQuizView(),
    );
  }

  Widget _buildQuizView() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              final question = _questions[index];
              final questionId = question['id'] as int;
              final options = Map<String, dynamic>.from(question['options']);

              return Card(
                margin: EdgeInsets.only(bottom: 16.h),
                color: Color(0xFFFDFCEA),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}. ${question['question_text']}',
                        style: TextStyle(
                          color: const Color(0xFF4F200D),
                          fontSize: 16.sp,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (question['image_url'] != null)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Image.network(
                            question['image_url'],
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported),
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(height: 10.h),
                      ...options.entries.map((option) {
                        return RadioListTile<String>(
                          title: Text(
                            option.value,
                            style: TextStyle(
                              color: const Color(0xFF4F200D),
                              fontSize: 16,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: option.key,
                          groupValue: _selectedAnswers[questionId],
                          onChanged: (value) {
                            setState(() {
                              _selectedAnswers[questionId] = value!;
                            });
                          },
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.r),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitQuiz,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                backgroundColor: const Color(0xFFED832F),
              ),
              child: Text(
                'Submit Jawaban',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    final hasFeedback =
        _submissionData?['teacher_feedback'] != null &&
        _submissionData!['teacher_feedback'].isNotEmpty;

    return ListView(
      padding: EdgeInsets.all(16.r),
      children: [
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                Text(
                  'Skor Akhir Kamu',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$_totalScore',
                  style: TextStyle(
                    fontSize: 64.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'dari 100 poin',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Card(
          color: hasFeedback ? Color(0xFFF9EF96) : Colors.orange.shade50,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Feedback dari Guru:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    color: Color(0xFF6C432D),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  hasFeedback
                      ? _submissionData!['teacher_feedback']
                      : 'Belum ada feedback dari guru.',
                  style: TextStyle(
                    fontStyle:
                        hasFeedback ? FontStyle.normal : FontStyle.italic,
                    color: hasFeedback ? Color(0xFF6C432D) : Color(0xFF6C432D),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Koreksi Jawaban:',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.h),
        ..._questions.map((question) {
          final questionId = question['id'];
          final selected = _selectedAnswers[questionId];
          final correct = question['correct_answer'];
          final isCorrect = selected == correct;
          final options = Map<String, String>.from(question['options']);
          final explanation = question['explanation'];

          return Card(
            color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
            margin: EdgeInsets.only(bottom: 12.h),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question['question_text'],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  if (question['image_url'] != null)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Image.network(
                        question['image_url'],
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                        fit: BoxFit.cover,
                      ),
                    ),
                  Text(
                    'Jawabanmu: $selected. ${options[selected] ?? ''}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color:
                          isCorrect
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                    ),
                  ),
                  if (!isCorrect)
                    Text(
                      'Jawaban Benar: $correct. ${options[correct] ?? ''}',
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontSize: 13.sp,
                      ),
                    ),
                  if (explanation != null && explanation.isNotEmpty ||
                      (question['explanation_image_url'] != null &&
                          question['explanation_image_url']
                              .toString()
                              .trim()
                              .isNotEmpty)) ...[
                    Divider(height: 20.h),
                    Text(
                      'Penjelasan:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                        fontSize: 13.sp,
                      ),
                    ),
                    if (question['explanation'] != null &&
                        question['explanation'].toString().isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Text(question['explanation']),
                      ),
                    if (question['explanation_image_url'] != null &&
                        question['explanation_image_url']
                            .toString()
                            .trim()
                            .isNotEmpty)
                      Image.network(
                        question['explanation_image_url'].toString().trim(),
                        height: 500.h,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder:
                            (context, error, stackTrace) => Column(
                              children: [
                                const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Gagal memuat gambar',
                                  style: TextStyle(color: Colors.grey.shade600),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                      ),
                  ],
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
