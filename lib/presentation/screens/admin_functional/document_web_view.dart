import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocumentWebView extends StatefulWidget {
  const DocumentWebView({super.key, required this.jwt});

  final String jwt;
  @override
  // ignore: library_private_types_in_public_api
  _DocumentWebViewState createState() => _DocumentWebViewState();
}

class _DocumentWebViewState extends State<DocumentWebView> {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(
      Uri.parse(
          'https://docs.google.com/gview?embedded=true&url=https://daurendan.ru/api/admin/document/10'),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3MTc2MzMxMDYsImV4cCI6MTcxNzYzNDAwNiwiaXNzIjoibWFya2V0LXNlcnZpY2UiLCJlbWFpbCI6ImFkbWluIiwicm9sZSI6IkFETUlOIn0.f8TAXKGbPsqjZ1PgJH4iAivNejnTJO5tk9tZhbXbPc0'
      },
    )
    ..setNavigationDelegate(NavigationDelegate(
      onUrlChange: (change) => print('11111122 ------------ $change'),
    ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Viewer'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
