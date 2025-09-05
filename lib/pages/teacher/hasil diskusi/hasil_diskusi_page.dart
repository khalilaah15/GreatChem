import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/pages/teacher/hasil%20diskusi/list_diskusi_kelompok_page.dart';
import 'package:greatchem/pages/teacher/hasil%20diskusi/penilaian_sebaya_page.dart';
import 'package:greatchem/pages/teacher/hasil%20diskusi/sesi_presentasi_page.dart';
import 'package:greatchem/pages/teacher/hasil%20diskusi/sesi_tanyajawab_page.dart';

class HasilDiskusiPage extends StatelessWidget {
  const HasilDiskusiPage({super.key});

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
          'Hasil Diskusi',
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
      body: Column(
        children: [
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w), // Diubah
            child: buildStyledButton(
              iconData: Icons.lightbulb_outline,
              text: 'Cek Diskusi Kelas Sesi Presentasi',
              onTap: () => _navigateTo(context, const SesiPresentasiPage()),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w), // Diubah
            child: buildStyledButton(
              iconData: Icons.people_outline,
              text: 'Cek Diskusi Kelas Sesi Tanya Jawab',
              onTap: () => _navigateTo(context, const SesiTanyajawabPage()),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w), // Diubah
            child: buildStyledButton(
              iconData: Icons.support,
              text: 'Cek Diskusi Kelompok',
              onTap: () =>
                  _navigateTo(context, const ListDiskusiKelompokPage()),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w), // Diubah
            child: buildStyledButton(
              iconData: Icons.description_outlined,
              text: 'Cek Penilaian Sebaya',
              // Menggunakan nama kelas dari file yang diimpor
              onTap: () => _navigateTo(context, const AssessmentResultPage()),
            ),
          ),
          const Spacer(),
          // Pastikan gambar ini tidak terlalu besar agar tidak menyebabkan overflow
          SizedBox(
            width: double.infinity,
            child: Image.asset('assets/images/bottom.png', fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }

  Widget buildStyledButton({
    required IconData iconData,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 24.w), // Diubah
        padding: EdgeInsets.all(6.r), // Diubah
        decoration: BoxDecoration(
          color: const Color(0xFFC2A180),
          borderRadius: BorderRadius.circular(50.r), // Diubah
          border: Border.all(color: const Color(0xFF6E4B34), width: 1.w), // Diubah
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r), // Diubah
              decoration: const BoxDecoration(
                color: Color(0xFF4a3826),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData,
                  color: const Color(0xFFfdd835), size: 28.sp), // Diubah
            ),
            SizedBox(width: 16.w), // Diubah
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp, // Diubah
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
