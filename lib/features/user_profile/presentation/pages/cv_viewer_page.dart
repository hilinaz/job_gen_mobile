import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

// For web platform
import 'dart:html' as html;

class CVViewerPage extends StatefulWidget {
  final Uint8List fileBytes;
  final String? fileName;

  const CVViewerPage({
    Key? key,
    required this.fileBytes,
    this.fileName,
  }) : super(key: key);

  @override
  _CVViewerPageState createState() => _CVViewerPageState();
}

class _CVViewerPageState extends State<CVViewerPage> {
  bool _isLoading = true;
  String? _tempFilePath;

  @override
  void initState() {
    super.initState();
    _saveAndOpenFile();
  }

  Future<void> _saveAndOpenFile() async {
    try {
      if (kIsWeb) {
        // For web, use a more reliable download approach
        try {
          // Convert bytes to JS compatible format
          final blob = html.Blob([widget.fileBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          
          // Create a temporary anchor element
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', widget.fileName ?? 'cv.pdf')
            ..style.display = 'none';
          
          // Add to DOM, trigger click, then clean up
          html.document.body?.children.add(anchor);
          anchor.click();
          
          // Clean up
          Future.delayed(const Duration(seconds: 1), () {
            try {
              anchor.remove();
              html.Url.revokeObjectUrl(url);
            } catch (e) {
              debugPrint('Error cleaning up: $e');
            }
          });
          
          if (mounted) {
            setState(() => _isLoading = false);
          }
        } catch (e) {
          debugPrint('Error creating download: $e');
          if (mounted) {
            setState(() => _isLoading = false);
            _showError('Failed to download file. Please try again.');
          }
        }
      } else {
        // For mobile/desktop platforms
        final tempDir = await getTemporaryDirectory();
        final extension = widget.fileName?.split('.').last ?? 'pdf';
        final file = File('${tempDir.path}/cv_${DateTime.now().millisecondsSinceEpoch}.$extension');
        await file.writeAsBytes(widget.fileBytes);
        
        if (mounted) {
          setState(() {
            _tempFilePath = file.path;
            _isLoading = false;
          });
          
          // Open the file with the default app
          await OpenFile.open(file.path);
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to open file: $e');
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    // Clean up the temporary file when done
    if (_tempFilePath != null) {
      try {
        final file = File(_tempFilePath!);
        if (file.existsSync()) {
          file.deleteSync();
        }
      } catch (e) {
        debugPrint('Error deleting temp file: $e');
      }
    }
    super.dispose();
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.grey[800],
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[800],
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName ?? 'CV Viewer'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildViewer(),
    );
  }

  Widget _buildViewer() {
    final extension = widget.fileName?.toLowerCase().split('.').last ?? '';
    final isPdf = extension == 'pdf';
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (kIsWeb) ...[
          const SizedBox(height: 40),
          Icon(
            isPdf ? Icons.picture_as_pdf : Icons.insert_drive_file,
            size: 80,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            widget.fileName ?? 'document.$extension',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ElevatedButton.icon(
              onPressed: _saveAndOpenFile,
              icon: const Icon(Icons.download_rounded, size: 24),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Download CV',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!isPdf) ...[
            const Text(
              'Note: This file type cannot be previewed in the browser.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
          ],
          const Text(
            'Click the button above to download the file to your device.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 40),
        ]
        else if (isPdf)
          Expanded(
            child: SfPdfViewer.memory(
              widget.fileBytes,
              canShowScrollHead: true,
              canShowScrollStatus: true,
            ),
          )
        else
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.insert_drive_file, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Preview not available for .$extension files',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _saveAndOpenFile,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open File'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
