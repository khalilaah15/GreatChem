import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    if(mounted) {
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
          'Target Capaian',
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
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedStudentId,
                          hint: const Text('Pilih Siswa'),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF8F6E9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide.none
                            ),
                          ),
                          items: _students.map<DropdownMenuItem<String>>(
                              (student) {
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
                          Card(
                            margin: EdgeInsets.only(
                                top: 50.h, left: 16.w, right: 16.w),
                            color: const Color(0xFFFDFCEA),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    "assets/images/track_back.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 40.h, horizontal: 24.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Atur Persentase Capaian:',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontSize: 16.sp
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      '${_currentPercentage.toInt()}%',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 48.sp,
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
                                        setState(
                                            () => _currentPercentage = value);
                                      },
                                    ),
                                    SizedBox(height: 32.h),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed:
                                            _isSaving ? null : _savePercentage,
                                        icon: _isSaving
                                            ? const SizedBox.shrink()
                                            : const Icon(
                                                Icons.save,
                                                color: Colors.white,
                                              ),
                                        label: _isSaving
                                            ? SizedBox(
                                                height: 20.h,
                                                width: 20.w,
                                                child:
                                                    const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Text(
                                                'Simpan',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFED832F,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.h),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
          Image.asset('assets/images/bottom.png',
              fit: BoxFit.cover, width: double.infinity),
        ],
      ),
    );
  }
}
