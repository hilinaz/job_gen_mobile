import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CVViewerPage extends StatelessWidget {
  final Uint8List pdfBytes;

  const CVViewerPage({required this.pdfBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CV Viewer')),
      body: SfPdfViewer.memory(pdfBytes),
    );
  }
}
