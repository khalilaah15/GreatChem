import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/pages/student/chemLearn/Mengorganisasikan/menu_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RumusanMasalahPage extends StatefulWidget {
  final VoidCallback onFinished;
  const RumusanMasalahPage({Key? key, required this.onFinished})
    : super(key: key);

  @override
  State<RumusanMasalahPage> createState() => _RumusanMasalahPageState();
}

class _RumusanMasalahPageState extends State<RumusanMasalahPage> {
  final TextEditingController _controller = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRumusanMasalah();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 🔹 Ambil data rumusan masalah dari database
  Future<void> _loadRumusanMasalah() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final response =
        await _supabase
            .from('rumusan_masalah')
            .select('rumusan')
            .eq('user_id', user.id)
            .maybeSingle();

    if (response != null && mounted) {
      setState(() {
        _controller.text = response['rumusan'] ?? '';
      });
    }
  }

  Future<void> _saveRumusanMasalah() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi rumusan masalah terlebih dahulu!'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _supabase
          .from('rumusan_masalah')
          .upsert(
            {
              'user_id': user.id,
              'rumusan': _controller.text.trim(),
              'updated_at': DateTime.now().toIso8601String(),
            },
            onConflict: 'user_id', 
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rumusan masalah berhasil disimpan!')),
        );
      }
    } catch (e) {
      debugPrint('Error saving: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat menyimpan.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToNextPage() {
    widget.onFinished();
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const MenuOrganisasiPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Koordinasi Reaksi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: const Color(0xFF4F200D),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: _goToNextPage,
          ),
          SizedBox(width: 5.w),
        ],
      ),
      backgroundColor: const Color(0xFFB07C48),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF9EF96),
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x3F000000),
                    blurRadius: 4.r,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Text(
                'Tuliskan permasalahan yang muncul mengenai laju reaksi di kolom yang sudah disediakan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF6C432D),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildSectionHeader(
              title: 'Rumusan Masalah',
              color: const Color(0xFF8B4513),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Tulis Rumusan Masalahmu disini!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'Rumusan masalah...',
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveRumusanMasalah,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9A00),
                fixedSize: Size(double.infinity, 45.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
              ),
              child:
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                        'KIRIM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ElevatedButton(
              onPressed: _goToNextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B4513),
                fixedSize: Size(double.infinity, 45.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
              ),
              child: Text(
                "Selanjutnya",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Spacer(),
          Image.asset('assets/images/bottom.png', fit: BoxFit.cover),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required Color color}) {
    return Row(
      children: [
        Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
