import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

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
          'Aktivasi Reaksi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: const Color(0xFF4F200D),
      ),
      backgroundColor: const Color(0xFFB07C48),
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
                  color: Colors.white,
                  fontSize: 21.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 16.h),
              _buildContentCard(contentSpan: buildContentText()),
              SizedBox(height: 16.h),
              Image.asset('assets/images/masalah_2.png'),
              SizedBox(height: 16.h),
              _buildContentCard2(
                contentSpan: buildContentText2(),
                title:
                    'Identifikasilah kondisi pada gambar dan teks di atas! menurutmu, bagaimana solusi ilmiah yang dapat dilakukan untuk menjaga kesuburan tanah tanpa menghentikan pemakaian pupuk?',
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

  Widget _buildContentCard({String? title, required InlineSpan contentSpan}) {
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
            RichText(textAlign: TextAlign.justify, text: contentSpan),
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

  TextSpan buildContentText() {
    return TextSpan(
      style: TextStyle(
        color: const Color(0xFF6C432D),
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      children: [
        const TextSpan(
          text:
              "Pertanian merupakan sektor vital dalam pemenuhan kebutuhan pangan di Indonesia. Untuk meningkatkan produktivitas, para petani kerap mengandalkan pupuk kimia dan pestisida dalam jumlah besar guna mempercepat pertumbuhan tanaman serta mencegah serangan hama. Salah satu praktik yang umum dilakukan adalah pemberian pupuk kimia dengan konsentrasi tinggi, yang memang secara jangka pendek dapat mempercepat proses penyerapan unsur hara oleh tanaman. Namun, penggunaan yang berlebihan justru dapat menyebabkan kerusakan tanah dalam jangka Panjang.",
        ),
        TextSpan(
          text: " (Penjelasan lebih detail)",
          style: const TextStyle(
            color: Colors.blueAccent,
          ),
          recognizer:
              TapGestureRecognizer()
                ..onTap = () async {
                  final Uri url = Uri.parse(
                    "https://drive.google.com/file/d/1QF9OYbGK7WWT5y7QtPZJlt_9bpLJ1fcS/view?usp=drive_link",
                  );
                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw Exception("Tidak bisa membuka link");
                  }
                },
        ),
        const TextSpan(
          text:
              "\n\nSecara kimiawi, proses pelarutan dan penyerapan unsur hara dari pupuk ke dalam tanah merupakan bentuk reaksi kimia heterogen yang dipengaruhi oleh faktor konsentrasi. Semakin tinggi konsentrasi pupuk yang diberikan, maka laju reaksi penyerapan oleh tanaman akan meningkat, yang artinya unsur hara dapat lebih cepat diserap. Namun, percepatan ini bersifat semu dan dapat berakibat fatal. Ketika tanah terus-menerus menerima input pupuk kimia dalam jumlah besar, residu senyawa-senyawa kimia akan terakumulasi dan menyebabkan terganggunya struktur tanah, bahkan mematikan mikroorganisme penting yang menjaga keseimbangan ekosistem tanah.",
        ),
        const TextSpan(
          text:
              "\n\nHal ini selaras dengan hasil penelitian yang dilakukan oleh Nurhayati (2021) di Kecamatan Gemuh, Kabupaten Kendal, yang menunjukkan bahwa penggunaan pupuk dan pestisida secara berlebihan menyebabkan peningkatan kadar residu kimia di dalam tanah. Dalam penelitiannya dijelaskan bahwa ''penggunaan pupuk dan pestisida kimia secara terus-menerus dan dalam jumlah besar menyebabkan akumulasi residu bahan kimia di tanah, yang mengakibatkan rusaknya struktur tanah dan terganggunya aktivitas mikroorganisme tanah'' (Nurhayati, 2021, hlm. 55). Tanah yang semula subur menjadi keras, tandus, dan kehilangan daya serap air serta unsur hara alami. Dalam jangka panjang, penurunan kesuburan tanah ini justru membuat hasil panen menurun, sehingga tidak sesuai dengan tujuan awal pemberian pupuk. ",
        ),
        TextSpan(
          text: " (Penjelasan lebih detail)",
          style: const TextStyle(
            color: Colors.blueAccent,
          ),
          recognizer:
              TapGestureRecognizer()
                ..onTap = () async {
                  final Uri url = Uri.parse(
                    "https://drive.google.com/file/d/1c0aj2637auPRE3HrywWFUw9cTyl4DXbn/view?usp=drive_link",
                  );
                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw Exception("Tidak bisa membuka link");
                  }
                },
        ),
        const TextSpan(
          text:
              "\n\nGambar berikut menunjukkan seorang petani sedang menaburkan pupuk kimia dalam jumlah besar. Jika praktik ini terus dilakukan tanpa memperhatikan takaran yang sesuai dan dampak jangka panjangnya, maka tanah akan kehilangan daya produktifnya akibat akumulasi senyawa kimia yang merusak.",
        ),
      ],
    );
  }

  Widget _buildContentCard2({String? title, required InlineSpan contentSpan}) {
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
            RichText(textAlign: TextAlign.justify, text: contentSpan),
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

  TextSpan buildContentText2() {
    return TextSpan(
      style: TextStyle(
        color: const Color(0xFF6C432D),
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      children: [
        const TextSpan(text: "Sumber : "),
        TextSpan(
          text: " rri.co.id",
          style: const TextStyle(
            color: Colors.blueAccent,
          ),
          recognizer:
              TapGestureRecognizer()
                ..onTap = () async {
                  final Uri url = Uri.parse(
                    "https://www.rri.co.id/daerah/232732/pemakaian-pupuk-kimia-berlebihan-sebabkan-lahan-pertanian-rusak",
                  );
                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw Exception("Tidak bisa membuka link");
                  }
                },
        ),
      ],
    );
  }
}
