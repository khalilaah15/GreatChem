import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import screenutil
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'Target Capaian Belajar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp, // Diubah
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: const Color(0xFF6C432D),
      ),
      backgroundColor: const Color(0xFFDFCFB5),
      body: Center(
        child: _percentage == null
            ? const CircularProgressIndicator()
            : Padding(
                padding: EdgeInsets.all(24.r), // Diubah
                child: Card(
                  color: const Color(0xFFFDFCEA),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r), // Diubah
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r), // Diubah
                      image: const DecorationImage(
                        image: AssetImage("assets/images/track_back.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 30.h,   // Diubah
                        horizontal: 20.w, // Diubah
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'SELAMAT',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF634A9F),
                              fontSize: 28.sp, // Diubah
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 16.h), // Diubah
                          SizedBox(
                            height: 100.h, // Diubah
                            width: 100.w,  // Diubah
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CircularProgressIndicator(
                                  value: _percentage! / 100,
                                  strokeWidth: 15.w,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Colors.green,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '$_percentage%',
                                    style: TextStyle(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15.h), // Diubah
                          Image.asset('assets/images/track.png'),
                          SizedBox(height: 15.h), // Diubah
                          Text(
                            'Terus tingkatkan prestasimu \ndan tetap semangat!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF634A9F),
                              fontSize: 20.sp, // Diubah
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 1.50,
                              letterSpacing: 0.20.w, // Diubah
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}