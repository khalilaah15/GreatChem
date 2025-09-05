import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Masalah3Page extends StatelessWidget {
  const Masalah3Page({super.key});

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
                title: 'Masalah 3',
                color: const Color(0xFF8B4513),
              ),
              SizedBox(height: 16.h),
              Text(
                'BPBD: Karhutla di Kalimantan Barat Terus Meluas',
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
                    'Kebakaran hutan dan lahan (karhutla) merupakan masalah serius yang sering terjadi di Indonesia, terutama pada musim kemarau. Reaksi pembakaran yang terjadi saat karhutla adalah reaksi eksoterm yang sangat dipengaruhi oleh suhu lingkungan. Ketika suhu di sekitar hutan meningkat akibat cuaca panas dan kering, maka energi kinetik partikel bahan bakar seperti daun kering dan ranting juga meningkat. Hal ini menyebabkan tumbukan antar partikel menjadi lebih efektif, sehingga laju reaksi pembakaran meningkat drastis dan api dengan cepat menyebar ke area lain.\n\nFenomena ini sangat umum terjadi di wilayah Sumatera dan Kalimantan. Salah satunya di Provinsi Kalimantan Barat, di mana pada tahun 2023, BPBD mencatat peningkatan luas kebakaran lahan secara signifikan, khususnya di Kabupaten Kubu Raya. Gambar berikut menunjukkan situasi kebakaran yang semakin meluas akibat suhu tinggi yang mempercepat reaksi pembakaran. Coba perhatikan gambar di bawah ini.',
              ),
              SizedBox(height: 16.h),
              Image.asset('assets/images/masalah_3.png'),
              SizedBox(height: 16.h),
              _buildContentCard(
                content:
                    'Pada gambar diatas, panas matahari yang terik pada musim kemarau meningkatkan suhu bahan bakar di permukaan tanah dan vegetasi hutan. Ini menjadikan proses pembakaran lebih cepat karena reaksi berlangsung pada suhu yang mendekati atau melebihi ambang aktivasi energi pembakaran. Secara kimia, kondisi ini menjelaskan bahwa suhu adalah salah satu faktor penting dalam laju reaksi, yang menyebabkan karhutla lebih mudah terjadi dan sulit dikendalikan.\n\nSelain itu, berdasarkan penelitian oleh Muharrama dan Widjonarko (2023), Kabupaten Kubu Raya merupakan salah satu wilayah dengan risiko tinggi terhadap kebakaran lahan gambut. Mereka mencatat bahwa struktur lahan gambut yang mudah terbakar dan menyimpan panas menjadi faktor utama meluasnya api di bawah permukaan tanah. Dalam laporan mereka disebutkan bahwa "jenis tanah gambut memiliki karakteristik menyimpan bara api dalam waktu lama, sehingga api dapat kembali muncul meski terlihat telah padam di permukaan”. Hal ini menambah tantangan dalam penanganan karhutla karena api tidak hanya menyebar di permukaan, tetapi juga di bawah tanah.\n\nKondisi tersebut tidak hanya menimbulkan kerusakan ekosistem, tetapi juga berdampak pada kesehatan masyarakat akibat kabut asap yang mengandung partikel berbahaya hasil pembakaran. Situasi ini menekankan pentingnya pengelolaan hutan yang bijak serta perlunya edukasi masyarakat tentang bahaya pembakaran terbuka, terutama di kawasan rawan seperti Kalimantan Barat.',
                title:
                    'Identifikasilah kondisi pada gambar dan teks di atas! Apa yang menyebabkan kebakaran hutan cepat meluas? Dan menurutmu, bagaimana solusi ilmiah yang dapat dilakukan untuk mencegah atau memperlambat penyebaran kebakaran tersebut?',
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
