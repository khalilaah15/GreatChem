import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/pages/auth/profile_page.dart';
import 'package:greatchem/pages/student/chemLearn/cptp_page.dart';
import 'package:greatchem/pages/student/chemTalk/room_list_page.dart';
import 'package:greatchem/pages/student/chemTrack/target_capaian_siswa.dart';
import 'package:greatchem/pages/student/chemTry/start_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SiswaPage extends StatefulWidget {
  const SiswaPage({super.key});

  @override
  State<SiswaPage> createState() => _SiswaPageState();
}

class _SiswaPageState extends State<SiswaPage> {
  String? fullName;
  bool isLoading = true;
  int _unlockedLevel = 1;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final response =
          await Supabase.instance.client
              .from('profiles')
              .select('name, unlocked_level')
              .eq('id', user.id)
              .single();

      if (mounted) {
        setState(() {
          fullName = response['name'];
          _unlockedLevel = response['unlocked_level'] ?? 1;
          isLoading = false;
        });
      }
    }
  }

  Future<void> _unlockNextLevel() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final newLevel = _unlockedLevel + 1;

    try {
      await Supabase.instance.client
          .from('profiles')
          .update({'unlocked_level': newLevel})
          .eq('id', user.id);

      if (mounted) {
        setState(() {
          _unlockedLevel = newLevel;
        });
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Selamat!'),
                content: Text('Anda telah membuka Bagian selanjutnya'),
                //$newLevel!
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF4F200D),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ProfilePage(),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/images/avatar.png',
                                  width: 50.w,
                                  height: 50.h,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selamat Datang',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
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
                                      SizedBox(width: 5.w),
                                      Text(
                                        '👋',
                                        style: TextStyle(fontSize: 24.sp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sudah Siap',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    'Belajar?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 42.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(
                                'assets/images/book.png',
                                height: 100.h,
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(25.r),
                      decoration: BoxDecoration(
                        color: Color(0xFFB07C48),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.r),
                          topRight: Radius.circular(50.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10.h),
                          Image.asset('assets/images/banner.png'),
                          SizedBox(height: 15.h),
                          _buildMenuCard(
                            context: context,
                            title: 'ChemLearn',
                            subtitle: 'Ruang Belajar',
                            section: 'Bagian 1',
                            iconPath: 'assets/images/chemlearn.png',
                            requiredLevel: 1,
                            currentUserLevel: _unlockedLevel,
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => CPTPPage(
                                          onFinished: _unlockNextLevel,
                                        ),
                                  ),
                                ),
                          ),
                          SizedBox(height: 16.h),
                          _buildMenuCard(
                            context: context,
                            title: 'ChemTry',
                            subtitle: 'Latihan Soal',
                            section: 'Bagian 2',
                            iconPath: 'assets/images/chemtry.png',
                            requiredLevel: 6,
                            currentUserLevel: _unlockedLevel,
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => StartPage(
                                          onFinished: _unlockNextLevel,
                                        ),
                                  ),
                                ),
                          ),
                          SizedBox(height: 16.h),
                          _buildMenuCard(
                            context: context,
                            title: 'ChemTalk',
                            subtitle: 'Ruang Diskusi',
                            section: 'Bagian 3',
                            iconPath: 'assets/images/chemtalk.png',
                            requiredLevel: 7,
                            currentUserLevel: _unlockedLevel,
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => RoomListPage(
                                          onFinished: _unlockNextLevel,
                                        ),
                                  ),
                                ),
                          ),
                          SizedBox(height: 16.h),
                          _buildMenuCard(
                            context: context,
                            title: 'ChemTrack',
                            subtitle: 'Pencapaian Hasil Belajar',
                            section: 'Bagian 4',
                            iconPath: 'assets/images/chemtrak.png',
                            requiredLevel: 8,
                            currentUserLevel: _unlockedLevel,
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const TargetCapaianSiswaPage(),
                                  ),
                                ),
                          ),
                          SizedBox(height: 30.h),
                        ],
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

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String section,
    required String iconPath,
    required VoidCallback onTap,
    required int requiredLevel,
    required int currentUserLevel,
  }) {
    final bool isLocked = currentUserLevel < requiredLevel;

    final cardContent = Container(
      width: double.infinity,
      height: 90.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 90.w,
            height: 90.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              image: DecorationImage(
                image: AssetImage(iconPath),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    section,
                    style: TextStyle(
                      color: const Color(0xFF6C432D),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF6C432D),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: const Color(0xFF6C432D),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16.sp,
            ),
          ),
        ],
      ),
    );
    final lockOverlay = Container(
      width: double.infinity,
      height: 90.h,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4), // Warna gelap transparan
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Icon(Icons.lock, color: Colors.white, size: 32.sp),
    );

    return GestureDetector(
      onTap:
          isLocked
              ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Selesaikan bagian sebelumnya terlebih dahulu!',
                    ),
                  ),
                );
              }
              : onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [cardContent, if (isLocked) lockOverlay],
      ),
    );
  }
}
