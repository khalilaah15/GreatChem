import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class MembimbingPage extends StatelessWidget {
  const MembimbingPage({super.key});
  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Tidak bisa membuka link: $url");
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
          'Membimbing Penyelidikan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: const Color(0xFF6C432D),
      ),
      backgroundColor: const Color(0xFFDFCFB5),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.r),
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFFFFDC7C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0x3F000000),
                    blurRadius: 4.r,
                    offset: const Offset(0, 0),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Text(
                '1. Diskusi dengan teman sekelompok mengenai permasalahan yang diperoleh \n2. Dilakukan kegiatan praktikum secara virtual menggunakan fitur G-Lab \n3. Unduh lembar laporan praktikum \n4. kumpulkan hasil kegiatan pengumpulan laporan pada kolom yang disediahkan.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color(0xFF6C432D),
                  fontSize: 14.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 15.h),
            GestureDetector(
              onTap: () {
                // aksi saat ditekan
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: SvgPicture.asset('assets/images/glab.svg'),
              ),
            ),
            SizedBox(height: 5.h),
            buildStyledButton(
              icon: Icons.download,
              iconData: Icons.document_scanner_rounded,
              text: 'Unduh Laporan\nHasil Praktikum',
              onTap: () {
                _openLink(
                  "https://docs.google.com/document/d/1zL9FZH2mtGtl9umWyUvSNIsUWp-AOebb/edit?usp=sharing&ouid=108413304217617381997&rtpof=true&sd=true",
                );
              },
            ),
            buildStyledButton(
              icon: Icons.upload,
              iconData: Icons.document_scanner_rounded,
              text: 'Pengumpulan Laporan\nHasil Praktikum',
              onTap: () {
                _openLink(
                  "https://drive.google.com/drive/folders/1reNWXvtB3QZifO3lr-Dj9DOb-YlNGRfK?usp=drive_link",
                );
              },
            ),
            const Spacer(), 
            Image.asset('assets/images/bottom.png', fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }

  Widget buildStyledButton({
    required IconData iconData,
    required String text,
    required VoidCallback onTap,
    required IconData icon,
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
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Icon(icon, color: Colors.white, size: 40.sp),
            ),
          ],
        ),
      ),
    );
  }
}
