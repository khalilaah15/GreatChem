import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/pages/auth/profile_page.dart';
import 'package:greatchem/pages/teacher/evaluasi/evaluasi_page.dart';
import 'package:greatchem/pages/teacher/hasil%20diskusi/hasil_diskusi_page.dart';
import 'package:greatchem/pages/teacher/hasil%20latihan/hasil_latihan_page.dart';
import 'package:greatchem/pages/teacher/target%20capaian/target_capaian_guru_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GuruPage extends StatefulWidget {
  const GuruPage({super.key});

  @override
  State<GuruPage> createState() => _GuruPageState();
}

class _GuruPageState extends State<GuruPage> {
  String? fullName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    // Error handling jika widget sudah di-dispose sebelum async selesai
    if (!mounted) return;

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response =
            await Supabase.instance.client
                .from('profiles')
                .select('name')
                .eq('id', user.id)
                .single();

        if (mounted) {
          setState(() {
            fullName = response['name'];
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        // Opsional: tampilkan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat profil: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF4F200D),
                image: DecorationImage(
                  image: AssetImage('assets/images/pattern.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Selamat Datang',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (isLoading)
                                    const SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  else
                                    Row(
                                      children: [
                                        Text(
                                          'Halo, ${fullName ?? 'User'}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '👋',
                                          style: TextStyle(fontSize: 24.sp),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              SizedBox(width: 12.w),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ProfilePage(),
                                    ),
                                  );
                                },
                                child: Image.asset('assets/images/avatar.png'),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/bookleft.png',
                                height: 160.h,
                                width: 160.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Sudah Siap',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Mengajar?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(25.r), // Diubah
                      decoration: BoxDecoration(
                        color: const Color(0xFFB07C48),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.r), // Diubah
                          topRight: Radius.circular(50.r), // Diubah
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 10.h), // Diubah
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                buildMenuCard(
                                  context: context,
                                  title: "Hasil Diskusi",
                                  iconPath: "assets/images/diskusi.png",
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const HasilDiskusiPage(),
                                        ),
                                      ),
                                ),
                                buildMenuCard(
                                  context: context,
                                  title: "Hasil Latihan Soal",
                                  iconPath: "assets/images/latihan.png",
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const ChemTryResultPage(),
                                        ),
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h), // Diubah
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                buildMenuCard(
                                  context: context,
                                  title: "Evaluasi",
                                  iconPath: "assets/images/evaluasi.png",
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const EvaluasiPage(),
                                        ),
                                      ),
                                ),
                                buildMenuCard(
                                  context: context,
                                  title: "Target Capaian",
                                  iconPath: "assets/images/capaian.png",
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const TargetCapaianGuruPage(),
                                        ),
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: 35.h), // Diubah
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuCard({
    required BuildContext context,
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.w,
        padding: EdgeInsets.all(8.r), // Diubah
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.r, // Diubah
              offset: Offset(0, 4.h), // Diubah
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: Center(child: Image.asset(iconPath, fit: BoxFit.fill)),
            ),
            SizedBox(height: 6.h), // Diubah
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF6C432D),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h), // Diubah
          ],
        ),
      ),
    );
  }
}
