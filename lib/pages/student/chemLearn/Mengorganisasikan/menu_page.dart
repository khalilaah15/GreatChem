import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greatchem/pages/student/chemLearn/Mengorganisasikan/artificial_intelligence_page.dart';
import 'package:greatchem/pages/student/chemLearn/Mengorganisasikan/ebook_page.dart';

class MenuOrganisasiPage extends StatelessWidget {
  const MenuOrganisasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    void _goToNextPage() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ArtificialIntelligencePage(),
        ),
      );
    }

    void _goToNextSecondPage() {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const EbookPage()));
    }

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
          'Mengorganisasikan Siswa',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
            child: Container(
              padding: EdgeInsets.all(24.r),
              width: double.infinity,
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
                '1. Peserta didik mengumpulkan berbagai informasi dan mengamati menggunakan fitur yang tersedia\n2. Gunakan fitur Artificial Intelligence (AI) sebagai pencarian inforbasi berdasarkan kata kunci',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color(0xFF6C432D),
                  fontSize: 14.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GestureDetector(
              onTap: _goToNextPage,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/AI.svg',
                    width: 90.w,
                    height: 90.h,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'AI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF6C432D),
                      fontSize: 20.sp,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GestureDetector(
              onTap: _goToNextSecondPage,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/ebook.svg',
                    width: 90.w,
                    height: 90.h,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'E-Book',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF6C432D),
                      fontSize: 20.sp,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Image.asset('assets/images/bottom.png', fit: BoxFit.cover),
        ],
      ),
    );
  }
}
