import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VirtualLaboratoryPage extends StatefulWidget {
  const VirtualLaboratoryPage({super.key});

  @override
  State<VirtualLaboratoryPage> createState() => _VirtualLaboratoryPageState();
}

class _VirtualLaboratoryPageState extends State<VirtualLaboratoryPage> {
  late final WebViewController _controller;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.white)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) {
                debugPrint("Loading $url");
              },
              onPageFinished: (url) {
                debugPrint("Finished $url");
              },
              onWebResourceError: (err) {
                debugPrint("Error: $err");
              },
            ),
          );

    _loadUrl();
  }

  Future<void> _loadUrl() async {
    const baseUrl = "https://greatchem-vlab.netlify.app/";
    final user = supabase.auth.currentUser;

    if (user != null) {
      // pakai id user Supabase
      final url = "$baseUrl?userId=${user.id}";
      _controller.loadRequest(Uri.parse(url));
    } else {
      _controller.loadRequest(Uri.parse(baseUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
