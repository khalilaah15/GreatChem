import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/pages/student/chemLearn/jelajahi_page.dart';

class CPTPPage extends StatelessWidget {
  final VoidCallback onFinished;
  const CPTPPage({Key? key, required this.onFinished}) : super(key: key);

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
          'CP dan TP',
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        title: 'Capaian Pembelajaran',
                        color: const Color(0xFF8B4513),
                      ),
                      SizedBox(height: 16.h),
                      _buildContentCard(
                        title: 'Capaian Pembelajaran Fase F',
                        content:
                            'Peserta didik mampu mengamati, menyelidiki dan menjelaskan fenomena sehari-hari sesuai kaidah kerja ilmiah dalam menjelaskan konsep kimia dalam kehidupan; menerapkan operasi matematik dalam perhitungan kimia; mempelajari sifat, struktur dan interaksi partikel dalam membentuk berbagai senyawa termasuk termodinamika dan penerapannya dalam keseharian; memahami dan menjelaskan aspek energi, laju dan kesetimbangan reaksi kimia; menggunakan konsep asam-basa dalam keseharian; menggunakan transformasi energi kimia dalam kehidupan termasuk termokimia dan elektrokimia; memahami kimia organik termasuk penerapannya dalam keseharian.',
                      ),
                      SizedBox(height: 16.h),
                      _buildSectionHeader(
                        title: 'Tujuan Pembelajaran',
                        color: const Color(0xFF8B4513),
                      ),
                      SizedBox(height: 16.h),
                      _buildContentCard(
                        content:
                            'Melalui kegiatan pembelajaran dengan model pembelajaran Problem Based Learning (PBL) siswa dapat:\n1. Mengidentifikasi permasalahan di lingkungan sekitar yang berkaitan dengan kinetika reaksi melalui pengamatan.\n2. Membuat rumusan masalah mengenai permasalahan faktor laju reaksi di lingkungan sekitar.\n3. Menganalisis konsep mengenai laju reaksi\n4. Mengevaluasi alternatif solusi berdasarkan permasalahan yang berhubungan dengan permasalahan faktor laju reaksi di lingkungan sekitar.\n5. Membuat solusi berdasarkan permasalahan yang telah dibuat.\n6. Menyajikan hasil temuan mengenai permasalahan faktor laju reaksi di lingkungan sekitar',
                      ),
                      SizedBox(height: 40.h),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JelajahiPage(onFinished: onFinished,),
                              ),
                            );
                          },
                          child: Container(
                            width: 200.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF8C00),
                              borderRadius: BorderRadius.circular(25.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Selanjutnya',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
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
    );
  }

  Widget _buildContentCard({String? title, required String content}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFCEA),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF6C432D),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5.h),
            ],
            Text(
              content,
              style: TextStyle(
                color: const Color(0xFF6C432D),
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget learningStep({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF6E4B34),
          ),
          child: Icon(icon, color: Colors.amber, size: 28.sp),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFD7B892),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFF6E4B34), width: 1.w),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
