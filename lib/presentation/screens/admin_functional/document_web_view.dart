import 'dart:typed_data';

import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class DocumentWebView extends ConsumerStatefulWidget {
  const DocumentWebView({super.key, required this.docInfo});

  final dynamic docInfo;

  @override
  // ignore: library_private_types_in_public_api
  _DocumentWebViewState createState() => _DocumentWebViewState();
}

class _DocumentWebViewState extends ConsumerState<DocumentWebView> {
  dynamic docInfo;
  late String authStateToken;
  late String documentUrl;
  Uint8List? _pdfData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    docInfo = widget.docInfo;
    authStateToken = ref.watch(authStateProvider).token;
    documentUrl = 'https://daurendan.ru/api/admin/document/${docInfo['id']}';
    _fetchPDFData();
  }

  Future<void> _fetchPDFData() async {
    if (docInfo['contentType'] == 'application/pdf') {
      final response = await http.get(
        Uri.parse(documentUrl),
        headers: {'Authorization': 'Bearer $authStateToken'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _pdfData = response.bodyBytes;
        });
      } else {
        // Handle error fetching PDF
        print('Failed to load PDF: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPDF = docInfo['contentType'] == 'application/pdf';

    return Scaffold(
      appBar: AppBar(
        title: Text('Document Viewer'),
      ),
      body: isPDF
          ? _pdfData != null
              ? PDFView(
                  pdfData: _pdfData!, // Display PDF from memory
                )
              : const Center(child: CircularProgressIndicator()) // Loading
          : WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadRequest(
                  Uri.parse(documentUrl),
                  headers: {'Authorization': 'Bearer $authStateToken'},
                ),
            ),
    );
  }
}


// import 'dart:typed_data';

// import 'package:elbazar_app/presentation/provider/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:webview_flutter/webview_flutter.dart';

// class DocumentWebView extends ConsumerStatefulWidget {
//   const DocumentWebView({super.key, required this.docInfo});

//   final dynamic docInfo;

//   @override
//   // ignore: library_private_types_in_public_api
//   _DocumentWebViewState createState() => _DocumentWebViewState();
// }

// class _DocumentWebViewState extends ConsumerState<DocumentWebView> {
//   dynamic docInfo;
//   late String authStateToken;
//   late String documentUrl;
//   Uint8List? _pdfData;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     docInfo = widget.docInfo;
//     authStateToken = ref.watch(authStateProvider).token;
//     documentUrl = 'https://daurendan.ru/api/admin/document/${docInfo['id']}';
//     _fetchDocumentData(); // Fetch data regardless of type
//   }

//   Future<void> _fetchDocumentData() async {
//     final response = await http.get(
//       Uri.parse(documentUrl),
//       headers: {'Authorization': 'Bearer $authStateToken'},
//     );

//     if (response.statusCode == 200) {
//       if (docInfo['name'].endsWith('.pdf')) {
//         setState(() {
//           _pdfData = response.bodyBytes;
//         });
//       }
//     } else {
//       // Handle error fetching data
//       print('Failed to load document: ${response.statusCode}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Document Viewer'),
//       ),
//       body: docInfo['name'].endsWith('.pdf')
//           ? _pdfData != null
//               ? PDFView(
//                   pdfData: _pdfData!, // Display PDF from memory
//                 )
//               : const Center(child: CircularProgressIndicator()) // Loading
//           : WebViewWidget(
//               controller: WebViewController()
//                 ..setJavaScriptMode(JavaScriptMode.unrestricted)
//                 ..loadRequest(
//                   Uri.parse(documentUrl),
//                   headers: {'Authorization': 'Bearer $authStateToken'},
//                 ),
//             ),
//     );
//   }
// }