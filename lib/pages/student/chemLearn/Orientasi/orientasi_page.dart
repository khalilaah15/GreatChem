import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/pages/student/chemLearn/Orientasi/masalah1_page.dart';
import 'package:greatchem/pages/student/chemLearn/Orientasi/masalah2_page.dart';
import 'package:greatchem/pages/student/chemLearn/Orientasi/masalah3_page.dart';
import 'package:greatchem/pages/student/chemLearn/Orientasi/masalah4_page.dart';

class OrientasiPage extends StatelessWidget {
  const OrientasiPage({super.key});
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
          'Orientasi',
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
              child: Text(
                'Orientasi Siswa Pada Masalah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF6C432D),
                  fontSize: 22.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildMenuCard(
                context: context,
                title: 'Masalah 1',
                subtitle:
                    'Perlindungan Konsumen Terhadap Bahan Kimia Berbahaya pada Tahu di Pasar Tradisional Rumbio',
                iconPath: 'assets/images/masalah1_icon.png',
                onTap: () => _navigateTo(context, const Masalah1Page()),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildMenuCard(
                context: context,
                title: 'Masalah 2',
                subtitle:
                    'Pemakaian Pupuk Kimia Berlebihan Sebabkan Lahan Pertanian Rusak',
                iconPath: 'assets/images/masalah2_icon.png',
                onTap: () => _navigateTo(context, const Masalah2Page()),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildMenuCard(
                context: context,
                title: 'Masalah 3',
                subtitle: 'BPBD: Karhutla di Kalimantan Barat Terus Meluas',
                iconPath: 'assets/images/masalah3_icon.png',
                onTap: () => _navigateTo(context, const Masalah3Page()),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildMenuCard(
                context: context,
                title: 'Masalah 4',
                subtitle:
                    'Pemanfaatan Limbah Tempurung Kelapa Menjadi Briket Untuk Bahan Bakar Alternatif',
                iconPath: 'assets/images/masalah4_icon.png',
                onTap: () => _navigateTo(context, const Masalah4Page()),
              ),
            ),
            const Spacer(),
            Image.asset('assets/images/bottom.png', fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(iconPath),
                      fit: BoxFit.fill,
                    ),
                  ),
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
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
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
}
