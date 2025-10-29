import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class Masalah1Page extends StatelessWidget {
  const Masalah1Page({super.key});

  Future<void> _onOpen(LinkableElement link) async {
    final Uri uri = Uri.parse(link.url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak bisa membuka ${link.url}');
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
                title: 'Masalah 1',
                color: const Color(0xFF8B4513),
              ),
              SizedBox(height: 16.h),
              Text(
                'Perlindungan Konsumen Terhadap Bahan Kimia Berbahaya pada Tahu di Pasar Tradisional Rumbio',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 16.h),
              Image.asset('assets/images/masalah_1.png'),
              SizedBox(height: 16.h),
              _buildContentCard(
                contentSpan: buildContentText(),
                title:
                    '\nAmatilah bacaan tentang penggunaan formalin dalam produksi tahu di atas!. Menurut pendapatmu, bagaimana pengaruh penggunaan bahan kimia seperti formalin terhadap perubahan alami tahu? Dan bagaimana cara lain yang dapat dilakukan untuk memperlambat kerusakan tahu tanpa menggunakan bahan kimia berbahaya seperti formalin, namun tetap menjaga kualitasnya?',
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
        const TextSpan(text: "Sumber : "),
        TextSpan(
          text: " beritajakarta.id",
          style: const TextStyle(
            color: Colors.blueAccent,
          ),
          recognizer:
              TapGestureRecognizer()
                ..onTap = () async {
                  final Uri url = Uri.parse(
                    "https://www.beritajakarta.id/read/23263/tahu-berformalin-ditemukan-di-beberapa-pasar-di-jakarta",
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
              "\n\nDi tengah maraknya konsumsi makanan berbasis kedelai, tahu tetap menjadi salah satu pangan lokal yang terjangkau, tinggi protein, dan dikonsumsi luas oleh masyarakat Indonesia. Namun, kebutuhan pasar yang tinggi seringkali tidak diiringi dengan praktik produksi yang aman. Salah satu permasalahan serius yang terjadi di lapangan adalah penggunaan bahan kimia berbahaya seperti formalin dalam proses produksi tahu, terutama di pasar tradisional. Studi yang dilakukan di Pasar Tradisional Rumbio, Kabupaten Kampar, menunjukkan bahwa sebagian pedagang tahu masih menggunakan formalin untuk memperpanjang umur simpan tahu dan menjaga tampilannya tetap segar",
        ),
        TextSpan(
          text: " (Putri & Indrayani, 2016)",
          style: const TextStyle(
            color: Colors.blueAccent,
          ),
          recognizer:
              TapGestureRecognizer()
                ..onTap = () async {
                  final Uri url = Uri.parse(
                    "https://drive.google.com/file/d/1dUuwQVvcx4D9GaXUEXT0X14ZMJXXGbFt/view?usp=drive_link",
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
              ".\n\nFenomena ini tidak hanya menjadi isu sosial dan kesehatan, tetapi juga menyentuh aspek fundamental dalam ilmu kimia, khususnya dalam bidang kinetika reaksi. Ilmu kimia mempelajari bagaimana suatu reaksi berlangsung, faktor-faktor yang memengaruhinya, dan bagaimana senyawa tertentu dapat mengubah kecepatan terjadinya suatu proses kimia, termasuk dalam konteks pengawetan makanan.",
        ),
        const TextSpan(
          text:
              "\n\nPerspektif kimia, penggunaan formalin (larutan formaldehida dalam air) ini secara langsung memengaruhi laju reaksi biokimia alami yang seharusnya terjadi dalam tahu. Normalnya, tahu yang tidak diawetkan akan mengalami proses degradasi protein secara alami oleh mikroorganisme, menghasilkan perubahan bau, warna, dan tekstur seiring waktu sebagai akibat dari reaksi oksidasi dan enzimatis. Penambahan formalin justru bertindak sebagai inhibitor, yaitu senyawa yang menghambat aktivitas mikroorganisme dan enzim, sehingga menurunkan laju reaksi degradasi tersebut secara signifikan. Dalam teori kinetika kimia, ini berarti nilai konstanta laju reaksi (k) menjadi lebih kecil, dan waktu yang dibutuhkan untuk terjadinya perubahan (reaksi) menjadi lebih lama.",
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
                    "https://drive.google.com/file/d/1Q9mUO9vpsGiI373OG-vAosdljLvDExBZ/view?usp=drive_link",
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
              "\n\nFenomena ini secara tidak langsung mengajarkan bahwa laju reaksi kimia tidak hanya dipengaruhi oleh suhu, konsentrasi, dan luas permukaan, tetapi juga sangat dipengaruhi oleh keberadaan zat penghambat (inhibitor). Formalin, dalam hal ini, memperpanjang masa simpan tahu secara tidak wajar dengan menekan proses reaksi kimia alami yang seharusnya menandai kerusakan bahan makanan. Sayangnya, meskipun dari sisi tampilan tahu tampak segar, secara kimia produk tersebut telah mengalami intervensi reaksi yang tidak alami dan berisiko tinggi bagi kesehatan konsumen.",
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
                    "https://drive.google.com/file/d/1OeXHlw0MjoQxcad07TzIIha6pIiYJkrI/view?usp=drive_link ",
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
