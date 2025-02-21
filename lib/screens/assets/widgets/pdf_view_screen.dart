import 'package:auscurator/screens/widgets_common/appbar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;

  // Pass the URL from the backend as a parameter
  PdfViewerScreen({required this.pdfUrl});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "PDF Viewer"),
      body: SfPdfViewer.network(
        widget.pdfUrl,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        enableDocumentLinkAnnotation: true,
      ),
    );
  }
}
