import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeerAssessmentPage extends StatefulWidget {
  const PeerAssessmentPage({Key? key}) : super(key: key);

  @override
  State<PeerAssessmentPage> createState() => _PeerAssessmentPageState();
}

class _PeerAssessmentPageState extends State<PeerAssessmentPage> {
  final _supabase = Supabase.instance.client;
  
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

  // Cek apakah siswa saat ini sudah pernah menilai siswa yang dipilih
  Future<void> _checkAssessmentStatus(String assessedUserId) async {
    setState(() {
      _hasAlreadyAssessed = true; // Asumsikan sudah, untuk loading state
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
    // Validasi: pastikan semua pertanyaan sudah dinilai
    if (_scores.length != _questions.length) {
      _showErrorSnackBar('Harap isi semua pertanyaan terlebih dahulu.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final userId = _supabase.auth.currentUser!.id;
      final totalScore = _scores.values.reduce((a, b) => a + b).toInt();
      
      // Mengubah skor dari Map<int, double> ke Map<String, int> untuk JSONB
      final scoresForJson = _scores.map((key, value) => MapEntry(key.toString(), value.toInt()));

      await _supabase.from('penilaian_sebaya').insert({
        'penilai_id': userId,
        'dinilai_id': _selectedStudentId!,
        'skor': scoresForJson,
        'total_skor': totalScore,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Penilaian berhasil dikirim!'), backgroundColor: Colors.green),
      );
      
      // Reset state setelah berhasil
      setState(() {
        _selectedStudentId = null;
        _scores.clear();
        _hasAlreadyAssessed = false;
      });

    } catch (e) {
      _showErrorSnackBar('Gagal mengirim penilaian. Anda mungkin sudah pernah menilai siswa ini.');
    } finally {
      setState(() {
        _isSubmitting = false;
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
        title: const Text('Penilaian Teman Sebaya'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildStudentDropdown(),
                const SizedBox(height: 20),
                if (_selectedStudentId != null) _buildAssessmentForm(),
              ],
            ),
    );
  }

  // Widget untuk dropdown memilih siswa
  Widget _buildStudentDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedStudentId,
      hint: const Text('Pilih teman yang akan dinilai'),
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
            _scores.clear(); // Reset skor saat ganti siswa
          });
          _checkAssessmentStatus(value);
        }
      },
    );
  }

  // Widget untuk menampilkan formulir penilaian atau pesan status
  Widget _buildAssessmentForm() {
    if (_hasAlreadyAssessed) {
      return Card(
        color: Colors.amber.shade100,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Anda sudah pernah menilai siswa ini.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Berikan penilaian (1-5) untuk setiap pertanyaan:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        ..._questions.asMap().entries.map((entry) {
          int index = entry.key;
          var question = entry.value;
          int questionId = question['id'];
          return _buildQuestionSlider(index + 1, question['teks_pertanyaan'], questionId);
        }),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitAssessment,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: _isSubmitting
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
                : const Text('Kirim Penilaian'),
          ),
        ),
      ],
    );
  }

  // Widget untuk satu pertanyaan dan slider-nya
  Widget _buildQuestionSlider(int number, String questionText, int questionId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$number. $questionText', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('1'),
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
                const Text('5'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
