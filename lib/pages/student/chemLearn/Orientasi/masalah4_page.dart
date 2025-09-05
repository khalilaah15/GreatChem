import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Masalah4Page extends StatelessWidget {
  const Masalah4Page({super.key});

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
                title: 'Masalah 4',
                color: const Color(0xFF8B4513),
              ),
              SizedBox(height: 16.h),
              Text(
                'Pemanfaatan Limbah Tempurung Kelapa Menjadi Briket Untuk Bahan Bakar Alternatif',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF6C432D),
                  fontSize: 19.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 16.h),
              Image.asset('assets/images/masalah_4.png'),
              SizedBox(height: 16.h),
              _buildContentCard(
                content:
                    'Upaya dalam menjaga kelestarian lingkungan sekaligus menjawab kebutuhan energi masyarakat yang terus meningkat, berbagai inovasi energi alternatif terus dikembangkan. Salah satunya adalah pemanfaatan limbah tempurung kelapa yang melimpah di daerah tropis seperti Indonesia. Di beberapa wilayah seperti Jawa Tengah dan Bali, limbah batok kelapa kini dimanfaatkan menjadi briket arang aktif, sebuah bahan bakar padat yang lebih ramah lingkungan dan ekonomis.\n\nProses pembuatan briket dari limbah tempurung kelapa diawali dengan penghancuran batok menjadi serbuk halus, yang kemudian dipadatkan dan dipanaskan hingga terbentuk briket yang mampu menghasilkan energi panas optimal. Tahapan ini tidak only bertujuan mengubah bentuk bahan mentah, tetapi juga meningkatkan kualitas hasil pembakaran, karena serbuk halus memiliki karakteristik lebih mudah terbakar dan menyimpan energi panas lebih efisien. Selain itu, struktur briket yang kompak memungkinkan nyala api lebih stabil dan tahan lama saat digunakan.\n\nMenurut Aisyah et al. (2024), pemanfaatan limbah tempurung kelapa menjadi briket memiliki keunggulan karena "memanfaatkan limbah rumah tangga dan industri kecil menjadi sumber energi alternatif yang bernilai ekonomis, sekaligus mengurangi volume limbah padat di lingkungan sekitar". Kualitas briket sangat dipengaruhi oleh ukuran partikel, tekanan pemadatan, serta suhu pemanasan selama proses produksi. Dalam proses pembakaran, karakteristik ini turut menentukan kualitas energi yang dihasilkan.\n\nSecara ilmiah, saat bahan baku semakin halus, proses pembakaran berjalan lebih efektif karena reaksi berlangsung lebih cepat. Namun, apabila bahan terlalu halus, pembakaran bisa menjadi terlalu cepat dan tidak stabil, menghasilkan asap berlebih serta menurunkan efisiensi energi. Oleh karena itu, penting untuk menjaga keseimbangan dalam proses produksi, mulai dari tahap penghalusan, pencampuran bahan perekat, hingga pemanasan akhir, agar diperoleh briket yang tidak hanya ramah lingkungan tetapi juga memiliki daya guna maksimal.\n\nPemanfaatan limbah seperti ini menunjukkan bahwa inovasi energi terbarukan bisa dikembangkan dari bahan-bahan lokal yang sebelumnya tidak bernilai. Selain ramah lingkungan, briket dari tempurung kelapa juga dapat menjadi solusi energi alternatif bagi masyarakat pedesaan, industri rumah tangga, maupun sektor UMKM, khususnya di tengah isu krisis energi global.',
                title:
                    'Identifikasilah kondisi yang terjadi pada proses pembuatan briket dari tempurung kelapa di atas!\nApa yang dilakukan masyarakat dalam mengolah limbah tersebut? Menurutmu, bagaimana solusi terbaik agar proses pembakaran briket tetap efektif namun tidak menghasilkan asap yang berlebihan?',
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
