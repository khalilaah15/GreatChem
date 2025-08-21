import 'dart:io';

import 'package:flutter/material.dart';
import 'package:greatchem/service/tugas_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SesiPresentasiPage extends StatefulWidget {
  const SesiPresentasiPage({super.key});

  @override
  State<SesiPresentasiPage> createState() => _SesiPresentasiPageState();
}

class _SesiPresentasiPageState extends State<SesiPresentasiPage> {
  final service = TugasSupabaseService();
  List<Map<String, dynamic>> _tugasList = [];

  @override
  void initState() {
    super.initState();
    _loadTugas();
  }

  Future<void> _loadTugas() async {
    final data = await service.getTugas();
    setState(() => _tugasList = data);
  }

  void _openFile(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sesi Presentasi")),
      body: Column(
        children: [
          Expanded(
            child:
                _tugasList.isEmpty
                    ? const Center(child: Text("Belum ada tugas dikumpulkan"))
                    : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Kelompok")),
                          DataColumn(label: Text("Berkas Tugas")),
                        ],
                        rows:
                            _tugasList.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(item['nama_kelompok'] ?? '')),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.red,
                                      ),
                                      onPressed:
                                          () => _openFile(item['file_url']),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
