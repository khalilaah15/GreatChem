import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:greatchem/service/tugas_supabase_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MengembangkanPage extends StatefulWidget {
  const MengembangkanPage({super.key});

  @override
  State<MengembangkanPage> createState() => _MengembangkanPageState();
}

class _MengembangkanPageState extends State<MengembangkanPage> {
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

  void _showUploadDialog() {
    final namaController = TextEditingController();
    File? pickedFile;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Upload Tugas"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      labelText: "Nama Kelompok",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.attach_file),
                    label: Text(
                      pickedFile == null ? "Pilih File" : "File dipilih",
                    ),
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        withData: true,
                      );

                      if (result != null && result.files.single.path != null) {
                        setStateDialog(() {
                          pickedFile = File(result.files.single.path!);
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (namaController.text.isEmpty || pickedFile == null)
                      return;

                    await service.uploadTugas(namaController.text, pickedFile!);
                    Navigator.pop(context);
                    _loadTugas();
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openFile(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tugas Kelompok")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showUploadDialog,
                icon: const Icon(Icons.add),
                label: const Text("Upload Tugas"),
              ),
            ),
          ),
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
