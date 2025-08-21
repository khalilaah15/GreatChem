import 'package:flutter/material.dart';
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
    return DefaultTabController(
      length: 2, // ada 2 tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Fitur Pencarian"),
          bottom: const TabBar(
            tabs: [Tab(text: "Klasifikasi"), Tab(text: "Cari Istilah")],
          ),
        ),
        body: TabBarView(
          children: [
            // ----------------- TAB 1: Klasifikasi -----------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _klasifikasiController,
                    decoration: InputDecoration(
                      labelText: "Masukkan permasalahan",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _searchKlasifikasi,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child:
                        _klasifikasiResults.isEmpty
                            ? const Text("Belum ada hasil")
                            : ListView.builder(
                              itemCount: _klasifikasiResults.length,
                              itemBuilder: (context, index) {
                                final item = _klasifikasiResults[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(item['permasalahan']),
                                    subtitle: Text(
                                      "Faktor: ${item['faktor_laju_reaksi']}",
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),

            // ----------------- TAB 2: Cari Istilah -----------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _istilahController,
                    decoration: InputDecoration(
                      labelText: "Masukkan istilah kimia",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _searchIstilah,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child:
                        _istilahResults.isEmpty
                            ? const Text("Belum ada hasil")
                            : ListView.builder(
                              itemCount: _istilahResults.length,
                              itemBuilder: (context, index) {
                                final item = _istilahResults[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(item['istilah_kimia']),
                                    subtitle: Text(item['penjelasan']),
                                  ),
                                );
                              },
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
