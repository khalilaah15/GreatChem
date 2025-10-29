import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greatchem/service/ai_supabase_service.dart';

class ArtificialIntelligencePage extends StatefulWidget {
  const ArtificialIntelligencePage({super.key});

  @override
  State<ArtificialIntelligencePage> createState() =>
      _ArtificialIntelligencePageState();
}

class _ArtificialIntelligencePageState
    extends State<ArtificialIntelligencePage> {
  final service = AISupabaseService();

  // controller untuk input
  final _klasifikasiController = TextEditingController();
  final _istilahController = TextEditingController();

  // hasil pencarian
  List<Map<String, dynamic>> _klasifikasiResults = [];
  List<Map<String, dynamic>> _istilahResults = [];

  void _searchKlasifikasi() async {
    final query = _klasifikasiController.text.trim();
    if (query.isEmpty) return;

    final res = await service.searchKlasifikasi(query);
    setState(() => _klasifikasiResults = res);
  }

  void _searchIstilah() async {
    final query = _istilahController.text.trim();
    if (query.isEmpty) return;

    final res = await service.searchIstilah(query);
    setState(() => _istilahResults = res);
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
          'Koordinasi Reaksi',
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
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SizedBox(height: 20.h),

            // TabBar (tetap di atas)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: const Color(0xFFED832F),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                indicatorColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFFED832F),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  SizedBox(
                    height: 36.h,
                    child: const Tab(
                      child: Text(
                        'Klasifikasi',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 36.h,
                    child: const Tab(
                      child: Text('Cari Kata', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: TabBarView(
                children: [
                  // ================= TAB 1: Klasifikasi =================
                  SingleChildScrollView(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.r),
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF9EF96),
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
                            '1. Masukkan contoh fenomena yang termasuk faktor laju reaksi untuk mengidentifikasi ke dalam faktor konsentrasi, luas permukaan, suhu, katalis \n2. Peserta didik juga bisa memasukkan istilah yang tidak diketahui \n3.Klik “Cari” untuk mengetahui hasilnya',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: const Color(0xFF6C432D),
                              fontSize: 14.sp,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Tulis pertanyaan atau istilahmu disini!',
                          style: TextStyle(
                            color:
                                Colors
                                    .white, // sesuaikan dengan tema background
                            fontSize: 16.sp,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        TextField(
                          controller: _klasifikasiController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            hintText: 'Rumusan masalah...',
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: _searchKlasifikasi,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFED832F),
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 32.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                          child: Text(
                            'Cari',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'AI VIREACT bantu kamu disini ya!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // >>> GANTI Expanded(...) MENJADI BEGINI <<<
                        if (_klasifikasiResults.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 32.h),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDFCEA),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Text(
                              "Belum ada hasil",
                              style: TextStyle(
                                color: const Color(0xFF6C432D),
                                fontSize: 20.sp,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true, // penting!
                            physics:
                                const NeverScrollableScrollPhysics(), // biar ikut scroll induk
                            itemCount: _klasifikasiResults.length,
                            itemBuilder: (context, index) {
                              final item = _klasifikasiResults[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDFCEA),
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: ListTile(
                                  title: Text(
                                    item['permasalahan'],
                                    style: TextStyle(
                                      color: const Color(0xFF6C432D),
                                      fontSize: 16.sp,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Faktor: ${item['faktor_laju_reaksi']}",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                  // ================= TAB 2: Cari Istilah =================
                  SingleChildScrollView(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.r),
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF9EF96),
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
                            '1. Masukkan contoh fenomena yang termasuk faktor laju reaksi untuk mengidentifikasi ke dalam faktor konsentrasi, luas permukaan, suhu, katalis \n2. Peserta didik juga bisa memasukkan istilah yang tidak diketahui \n3.Klik “Cari” untuk mengetahui hasilnya',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: const Color(0xFF6C432D),
                              fontSize: 14.sp,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Tulis pertanyaan atau istilahmu disini!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        TextField(
                          controller: _istilahController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            hintText: 'Masukkan istilah Kimia...',
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: _searchIstilah,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFED832F),
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 32.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                          child: Text(
                            'Cari',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'AI VIREACT bantu kamu disini ya!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // >>> GANTI Expanded(...) MENJADI BEGINI <<<
                        if (_istilahResults.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 32.h),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDFCEA),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Text(
                              "Belum ada hasil",
                              style: TextStyle(
                                color: const Color(0xFF6C432D),
                                fontSize: 20.sp,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _istilahResults.length,
                            itemBuilder: (context, index) {
                              final item = _istilahResults[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDFCEA),
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: ListTile(
                                  title: Text(
                                    item['istilah_kimia'],
                                    style: TextStyle(
                                      color: const Color(0xFF6C432D),
                                      fontSize: 16.sp,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    item['penjelasan'],
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
