import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/pages/student/chemLearn/Membimbing/membimbing_page.dart';
import 'package:greatchem/pages/student/chemLearn/Menganalisis/diskusi_kelas_page.dart';
import 'package:greatchem/pages/student/chemLearn/Mengembangkan/mengembangkan_page.dart';
import 'package:greatchem/pages/student/chemLearn/Mengorganisasikan/rumusan_masalah_page.dart';
import 'package:greatchem/pages/student/chemLearn/Orientasi/orientasi_page.dart';

class JelajahiPage extends StatelessWidget {
  final VoidCallback onFinished;
  const JelajahiPage({Key? key, required this.onFinished}) : super(key: key);

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
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
        backgroundColor: const Color(0xFF6C432D),
      ),
      backgroundColor: const Color(0xFFDFCFB5),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
            child: buildStyledButton(
              context: context,
              iconData: Icons.lightbulb_outline,
              text: 'Orientasi Siswa pada Masalah',
              onTap: () => _navigateTo(context, const OrientasiPage()),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: buildStyledButton(
              context: context,
              iconData: Icons.people_outline,
              text: 'Mengorganisasikan Siswa untuk Belajar',
              onTap: () => _navigateTo(context, const RumusanMasalahPage()),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: buildStyledButton(
              context: context,
              iconData: Icons.support,
              text: 'Membimbing Penyelidikan Individual maupun Kelompok',
              onTap: () => _navigateTo(context, const MembimbingPage()),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: buildStyledButton(
              context: context,
              iconData: Icons.description_outlined,
              text: 'Mengembangkan dan Menyajikan Hasil Karya',
              onTap: () => _navigateTo(context, const MengembangkanPage()),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: buildStyledButton(
              context: context,
              iconData: Icons.analytics_outlined,
              text: 'Menganalisis & Mengevaluasi Proses Pemecahan Masalah',
              onTap:
                  () => _navigateTo(
                    context,
                    DiskusiKelasPage(onFinished: onFinished),
                  ),
            ),
          ),
          const Spacer(),
          Image.asset('assets/images/bottom.png', fit: BoxFit.cover),
        ],
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
}
