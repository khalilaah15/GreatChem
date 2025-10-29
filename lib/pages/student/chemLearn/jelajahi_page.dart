import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/pages/student/chemLearn/Membimbing/membimbing_page.dart';
import 'package:greatchem/pages/student/chemLearn/Menganalisis/diskusi_kelas_page.dart';
import 'package:greatchem/pages/student/chemLearn/Mengembangkan/mengembangkan_page.dart';
import 'package:greatchem/pages/student/chemLearn/Mengorganisasikan/rumusan_masalah_page.dart';
import 'package:greatchem/pages/student/chemLearn/Orientasi/orientasi_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JelajahiPage extends StatefulWidget {
  final VoidCallback onFinished;
  const JelajahiPage({Key? key, required this.onFinished}) : super(key: key);

  @override
  State<JelajahiPage> createState() => _JelajahiPageState();
}

class _JelajahiPageState extends State<JelajahiPage> {
  int _unlockedLevel = 1;
  bool isLoading = true;

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

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
          _unlockedLevel = response['unlocked_level'] ?? 1;
          isLoading = false;
        });
      }
    }
  }

  Future<void> _unlockNextLevel(int currentLevel) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final newLevel = currentLevel >= 5 ? 6 : currentLevel + 1;

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
                title: const Text('Selamat!'),
                content: Text('Anda telah membuka bagian selanjutnya'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    } catch (e) {
      debugPrint('Gagal memperbarui level: $e');
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
          'Mari Jelajahi Dunia',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: const Color(0xFF4F200D),
      ),
      backgroundColor: const Color(0xFFB07C48),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildMenuCard(
                    context: context,
                    title: "Aktivasi Reaksi",
                    iconPath: "assets/images/aktivasi.png",
                    requiredLevel: 1,
                    currentUserLevel: _unlockedLevel,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => OrientasiPage(
                                  onFinished: () => _unlockNextLevel(1),
                                ),
                          ),
                        ),
                  ),
                  buildMenuCard(
                    context: context,
                    title: "Koordinasi Reaksi",
                    iconPath: "assets/images/koordinasi.png",
                    requiredLevel: 2,
                    currentUserLevel: _unlockedLevel,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => RumusanMasalahPage(
                                  onFinished: () => _unlockNextLevel(2),
                                ),
                          ),
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildMenuCard(
                    context: context,
                    title: "Eksplorasi Reaksi",
                    iconPath: "assets/images/eksplorasi.png",
                    requiredLevel: 3,
                    currentUserLevel: _unlockedLevel,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MembimbingPage(
                                  onFinished: () => _unlockNextLevel(3),
                                ),
                          ),
                        ),
                  ),
                  buildMenuCard(
                    context: context,
                    title: "Sintesis Reaksi",
                    iconPath: "assets/images/sintesis.png",
                    requiredLevel: 4,
                    currentUserLevel: _unlockedLevel,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MengembangkanPage(
                                  onFinished: () => _unlockNextLevel(4),
                                ),
                          ),
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: buildMenuCard(
                context: context,
                title: "Kajian Reaksi",
                iconPath: "assets/images/kajian.png",
                requiredLevel: 5,
                currentUserLevel: _unlockedLevel,
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DiskusiKelasPage(
                              onFinished: () => _unlockNextLevel(5),
                            ),
                      ),
                    ),
              ),
            ),
            Image.asset('assets/images/bottom.png', fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }

  Widget buildStyledButton({
    required BuildContext context,
    required IconData iconData,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 24.w),
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: const Color(0xFFC2A180),
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: const Color(0xFF6E4B34), width: 1.w),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: const BoxDecoration(
                color: Color(0xFF4a3826),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: const Color(0xFFfdd835),
                size: 28.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
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
    required int requiredLevel,
    required int currentUserLevel,
  }) {
    final bool isLocked = currentUserLevel < requiredLevel;
    final cardContent = Container(
      width: 140.w,
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
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
          SizedBox(height: 6.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF6C432D),
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );

    final lockOverlay = Container(
      width: 140.w,
      height: 155.h,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
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
