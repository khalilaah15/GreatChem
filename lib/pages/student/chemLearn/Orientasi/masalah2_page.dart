import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Masalah2Page extends StatelessWidget {
  const Masalah2Page({super.key});

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
            color:  Colors.white,
            fontSize: 24.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: const Color(0xFF6C432D),
      ),
      backgroundColor: const Color(0xFFDFCFB5),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.r),
          child: Column(
            children: [
              _buildSectionHeader(
                title: 'Masalah 2',
                color: const Color(0xFF8B4513),
              ),
              SizedBox(height: 16.h),
              Text(
                'Pemakaian Pupuk Kimia Berlebihan Sebabkan Lahan Pertanian Rusak',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF6C432D),
                  fontSize: 21.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 16.h),
              _buildContentCard(
                content:
                    'Pertanian merupakan sektor vital dalam pemenuhan kebutuhan pangan di Indonesia. Untuk meningkatkan produktivitas, para petani kerap mengandalkan pupuk kimia dan pestisida dalam jumlah besar guna mempercepat pertumbuhan tanaman serta mencegah serangan hama. Salah satu praktik yang umum dilakukan adalah pemberian pupuk kimia dengan konsentrasi tinggi, yang memang secara jangka pendek dapat mempercepat proses penyerapan unsur hara oleh tanaman. Namun, penggunaan yang berlebihan justru dapat menyebabkan kerusakan tanah dalam jangka Panjang.\n\nSecara kimiawi, proses pelarutan dan penyerapan unsur hara dari pupuk ke dalam tanah merupakan bentuk reaksi kimia heterogen yang dipengaruhi oleh faktor konsentrasi. Semakin tinggi konsentrasi pupuk yang diberikan, maka laju reaksi penyerapan oleh tanaman akan meningkat, yang artinya unsur hara dapat lebih cepat diserap. Namun, percepatan ini bersifat semu dan dapat berakibat fatal. Ketika tanah terus-menerus menerima input pupuk kimia dalam jumlah besar, residu senyawa-senyawa kimia akan terakumulasi dan menyebabkan terganggunya struktur tanah, bahkan mematikan mikroorganisme penting yang menjaga keseimbangan ekosistem tanah.\n\nHal ini selaras dengan hasil penelitian yang dilakukan oleh Nurhayati (2021) di Kecamatan Gemuh, Kabupaten Kendal, yang menunjukkan bahwa penggunaan pupuk dan pestisida secara berlebihan menyebabkan peningkatan kadar residu kimia di dalam tanah. Dalam penelitiannya dijelaskan bahwa "penggunaan pupuk dan pestisida kimia secara terus-menerus dan dalam jumlah besar menyebabkan akumulasi residu bahan kimia di tanah, yang mengakibatkan rusaknya struktur tanah dan terganggunya aktivitas mikroorganisme tanah". Tanah yang semula subur menjadi keras, tandus, dan kehilangan daya serap air serta unsur hara alami. Dalam jangka panjang, penurunan kesuburan tanah ini justru membuat hasil panen menurun, sehingga tidak sesuai dengan tujuan awal pemberian pupuk.',
              ),
              SizedBox(height: 16.h),
              Image.asset('assets/images/masalah_2.png'),
              SizedBox(height: 16.h),
              _buildContentCard(
                content:
                    'Pada gambar di atas terlihat petani sedang menaburkan pupuk kimia dengan konsentrasi tinggi untuk mempercepat pertumbuhan tanaman. Namun, jika dilakukan terus menerus tanpa takaran yang sesuai, tanah akan menjadi keras dan tandus akibat reaksi penyerapan yang terlalu cepat serta menumpuknya residu pupuk di dalam tanah.',
                title:
                    'Amatilah bacaan tentang penggunaan pupuk kimia yang berlebihan di atas! Menurut pendapatmu, bagaimana konsentrasi pupuk dapat memengaruhi kecepatan pertumbuhan tanaman dan apa saja dampak negatif yang mungkin timbul akibat penggunaan pupuk kimia secara berlebihan? Serta, bagaimana cara yang lebih bijaksana dalam meningkatkan hasil panen tanpa merusak kesuburan tanah?',
              ),
            ],
          ),
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
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
            Text(
              content,
              style: TextStyle(
                color: const Color(0xFF6C432D),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            if (title != null) ...[
              SizedBox(height: 10.h),
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF6C432D),
                  fontSize: 13.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 5.h),
            ],
          ],
        ),
      ),
    );
  }
}
