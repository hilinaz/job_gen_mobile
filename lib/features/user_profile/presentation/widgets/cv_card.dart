import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_gen_mobile/features/files/domain/entities/jg_file.dart';
import 'package:job_gen_mobile/features/files/domain/repositories/file_repository.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_user_files.dart';
import 'package:job_gen_mobile/features/files/presentation/bloc/files_bloc.dart';
import 'package:job_gen_mobile/features/files/presentation/bloc/files_bloc_state.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/pages/cv_viewer_page.dart';

// Use conditional imports
// This import is only used on web platforms
import 'package:flutter/foundation.dart' show kIsWeb;

// Import web utilities conditionally
// For web platform
import 'package:universal_html/html.dart'
    if (dart.library.io) 'package:job_gen_mobile/features/user_profile/presentation/utils/web_stubs.dart'
    as html;

// For platformViewRegistry
import 'package:flutter/services.dart';

// Import for web-specific code
// This is a workaround for conditional imports with dart:ui
import 'package:job_gen_mobile/features/user_profile/presentation/utils/platform_view_registry.dart'
    as platform_registry;

class CVCard extends StatefulWidget {
  final JgFile? cvFile;
  final String? userId;
  final FileRepository fileRepository;
  final Function(JgFile)? onCVUploaded;
  final VoidCallback? onCVDeleted;

  const CVCard({
    super.key,
    required this.fileRepository,
    this.cvFile,
    this.userId,
    this.onCVUploaded,
    this.onCVDeleted,
  });

  @override
  State<CVCard> createState() => _CVCardState();
}

class _CVCardState extends State<CVCard> {
  bool _isUploading = false;
  bool _isDeleting = false;
  bool _isDownloading = false;
  bool _isLoading = false;
  String? _errorMessage;
  late final Dio _dio;
  Uint8List? _currentFileBytes;
  JgFile? _cvFile;

  // Helper method to show snackbar messages
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[800] : Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _loadCVFile();
  }

  @override
  void didUpdateWidget(CVCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userId != oldWidget.userId ||
        widget.cvFile != oldWidget.cvFile) {
      _loadCVFile();
    }
  }

  Future<void> _loadCVFile() async {
    if (widget.userId == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final getFiles = GetUserFiles(widget.fileRepository);
      final result = await getFiles(
        GetUserFilesParams(userId: widget.userId!, fileType: 'cv'),
      );

      setState(() {
        result.fold(
          (failure) {
            _errorMessage = failure.toString();
            _cvFile = null;
          },
          (files) {
            _cvFile = files.isNotEmpty ? files.first : null;
          },
        );
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load CV';
        _cvFile = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleFileDownloaded(String filePath) {
    if (!mounted) return;

    setState(() => _isDownloading = false);

    if (kIsWeb) {
      _showSnackBar('CV downloaded successfully!');
    } else {
      // For mobile, you might want to open the file or show a dialog
      _showSnackBar('CV downloaded to $filePath');
    }
  }

  Future<void> _saveFile(Uint8List bytes, String fileName) async {
    try {
      if (kIsWeb) {
        final blob = html.Blob([bytes]);

        // Create and trigger download using window.open for web
        final downloadUrl = html.Url.createObjectUrl(blob);
        final downloadLink = html.AnchorElement(href: downloadUrl)
          ..setAttribute('download', fileName)
          ..style.display = 'none';

        html.document.body?.children.add(downloadLink);
        downloadLink.click();

        // Clean up
        Future.delayed(const Duration(seconds: 1), () {
          downloadLink.remove();
          html.Url.revokeObjectUrl(downloadUrl);
        });
      } else {
        // For mobile, you might want to open the file or show a dialog
        // For now, just print the file path
        print('File saved to: $fileName');
      }
    } catch (e) {
      _showSnackBar('Failed to save file: $e');
    }
  }

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }

  // Handle file uploaded event from the bloc
  void _handleFileUploaded(JgFile file) {
    if (!mounted) return;

    setState(() {
      _isUploading = false;
      _currentFileBytes = null;
    });

    _showSnackBar('CV uploaded successfully');

    if (widget.onCVUploaded != null) {
      widget.onCVUploaded!(file);
    }
  }

  // Handle file deleted event from the bloc
  void _handleFileDeleted() {
    if (!mounted) return;

    setState(() {
      _isDeleting = false;
      _currentFileBytes = null;
    });

    _showSnackBar('CV deleted successfully');

    if (widget.onCVDeleted != null) {
      widget.onCVDeleted!();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set up bloc listeners
    return BlocListener<FilesBloc, FilesState>(
      listener: (context, state) {
        if (state is FilesError) {
          _showSnackBar('Error: ${state.message}');
        } else if (state is FilesUploaded) {
          _handleFileUploaded(state.file);
        } else if (state is FilesDeleted) {
          _handleFileDeleted();
        } else if (state is FilesDownloaded) {
          _handleFileDownloaded(state.filePath);
        }
      },
      child: BlocBuilder<FilesBloc, FilesState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'CV\'s',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),
                // CV Status
                _buildCVStatus(state),
                const SizedBox(height: 24),
                // Section Label
                Center(
                  child: Text(
                    'Professional CV',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Upload Button
                _buildActionButtons(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCVStatus(FilesState state) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (_cvFile != null) {
      return Column(
        children: [
          // CV Info Section
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.insert_drive_file,
                  color: Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your CV is ready!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_cvFile!.fileName} • ${(_cvFile!.size / 1024).toStringAsFixed(2)} KB',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.blue),
                  onPressed: _viewCV,
                  tooltip: 'View CV',
                ),
              ],
            ),
          ),
          // Add some spacing before buttons
          const SizedBox(height: 8),
        ],
      );
    }

    // No CV uploaded state
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No CV uploaded yet. Upload your CV to apply for jobs.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(FilesState state) {
    final hasCV = _cvFile != null;

    return Center(
      child: Column(
        children: [
          // Upload/Replace CV Button
          ElevatedButton(
            onPressed: _isUploading || _isDeleting || _isDownloading
                ? null
                : _pickAndUploadCV,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(220, 50),
              backgroundColor: const Color(0xFF7BBFB3),
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 14.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 2,
            ),
            child: Text(
              hasCV ? 'Replace CV' : 'Upload your CV',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Download Button (only if CV exists)
          if (_cvFile != null) ...[
            ElevatedButton(
              onPressed: _isUploading || _isDeleting || _isDownloading
                  ? null
                  : _downloadCV,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(220, 50),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF7BBFB3), width: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 14.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 0,
              ),
              child: _isDownloading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF7BBFB3),
                        ),
                      ),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.download, color: Color(0xFF7BBFB3)),
                        SizedBox(width: 8),
                        Text(
                          'Download CV',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7BBFB3),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
          ],

          // Delete Button (only if CV exists)
          if (widget.cvFile != null)
            ElevatedButton(
              onPressed: _isUploading || _isDeleting || _isDownloading
                  ? null
                  : _deleteCV,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(220, 50),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.red, width: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 14.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 0,
              ),
              child: _isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : const Text(
                      'Delete CV',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
            ),
        ],
      ),
    );
  }

  Future<void> _downloadCV() async {
    if (_cvFile == null) return;

    try {
      setState(() => _isDownloading = true);

      // Get download URL
      final result = await widget.fileRepository.downloadUrl(
        fileId: _cvFile!.id,
      );

      // Handle the result using fold
      await result.fold(
        (failure) async {
          _showSnackBar('Failed to get download URL: ${failure.message}');
        },
        (url) async {
          if (kIsWeb) {
            await _downloadFileWebFromUrl(url, _cvFile!.fileName);
          } else {
            final bytesResult = await widget.fileRepository.downloadFile(
              fileId: _cvFile!.id,
            );

            bytesResult.fold(
              (failure) {
                _showSnackBar('Download failed: ${failure.message}');
              },
              (bytes) {
                _saveFile(bytes, _cvFile!.fileName);
              },
            );
          }
        },
      );
    } catch (e) {
      _showSnackBar('Download failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  // Add this method for web download from URL
  Future<void> _downloadFileWebFromUrl(String url, String fileName) async {
    try {
      // Fetch the file as bytes
      final response = await _dio.get<Uint8List>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        // Create blob and download
        final blob = html.Blob([response.data!]);
        final blobUrl = html.Url.createObjectUrlFromBlob(blob);

        final anchor = html.AnchorElement(href: blobUrl)
          ..setAttribute('download', fileName)
          ..click();

        // Clean up
        html.Url.revokeObjectUrl(blobUrl);
        _showSnackBar('Download started!');
      } else {
        throw Exception('Failed to download file');
      }
    } catch (e) {
      _showSnackBar('Download error: $e');

      // Fallback: open the URL in new tab (user can manually download)
      html.window.open(url, '_blank');
    }
  }

  Future<void> _pickAndUploadCV() async {
    print('_pickAndUploadCV: Starting file picker...');
    try {
      print('_pickAndUploadCV: Opening file picker...');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: true, // This ensures we get file bytes
      );

      print(
        '_pickAndUploadCV: File picker result: ${result != null ? 'File selected' : 'No file selected'}',
      );

      if (result != null) {
        print('_pickAndUploadCV: File selected - ${result.files.single.name}');
        print(
          '_pickAndUploadCV: File size - ${result.files.single.size} bytes',
        );

        if (result.files.single.bytes != null) {
          print('_pickAndUploadCV: File bytes loaded successfully');
          setState(() => _isUploading = true);

          // On web, we can directly use the bytes from the file picker
          final bytes = result.files.single.bytes!;
          final fileName = result.files.single.name;
          final fileExtension = fileName.split('.').last.toLowerCase();

          print(
            '_pickAndUploadCV: File details - Name: $fileName, Extension: $fileExtension',
          );

          // Map common extensions to MIME types
          final mimeTypes = {
            'pdf': 'application/pdf',
            'doc': 'application/msword',
            'docx':
                'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
          };

          final contentType =
              mimeTypes[fileExtension] ?? 'application/octet-stream';
          print('_pickAndUploadCV: Determined content type: $contentType');

          if (!mounted) {
            print('_pickAndUploadCV: Widget not mounted, aborting');
            return;
          }

          print('_pickAndUploadCV: Dispatching UploadFileEvent to FilesBloc');
          context.read<FilesBloc>().add(
            UploadFileEvent(
              fileName: fileName,
              bytes: bytes,
              contentType: contentType,
              fileType: 'document',
            ),
          );
        } else {
          print('_pickAndUploadCV: Failed to read file bytes');
          _showSnackBar('Failed to read file. Please try again.');
        }
      } else {
        print('_pickAndUploadCV: No file selected');
      }
    } catch (e, stackTrace) {
      print('_pickAndUploadCV: Error occurred:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      _showSnackBar('Failed to pick file: ${e.toString()}');
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _deleteCV() async {
    if (widget.cvFile == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete CV'),
        content: const Text('Are you sure you want to delete your CV?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isDeleting = true);
      context.read<FilesBloc>().add(DeleteFileEvent(fileId: widget.cvFile!.id));

      if (widget.onCVDeleted != null) {
        widget.onCVDeleted!();
      }
    }
  }

  Future<void> _viewCV() async {
    if (widget.cvFile == null) return;

    try {
      // If we have the file bytes (e.g., from recent upload), use them
      if (widget.cvFile?.bytes != null) {
        _openCVViewer(widget.cvFile!.bytes!);
        return;
      }

      final result = await context.read<FilesBloc>().downloadFile(
        widget.cvFile!.id,
      );

      result.fold(
        (failure) => _showSnackBar('Failed to get CV: ${failure.message}'),
        (fileUrl) async {
          try {
            if (kIsWeb) {
              // On web, we'll download the file and display it in an embedded viewer
              setState(() => _isDownloading = true);
              final response = await _dio.get<Uint8List>(
                fileUrl,
                options: Options(responseType: ResponseType.bytes),
              );

              if (response.statusCode == 200 && response.data != null) {
                setState(() => _isDownloading = false);
                _openCVViewer(Uint8List.fromList(response.data!));
              } else {
                throw Exception('Failed to download file');
              }
            } else {
              // On mobile, download the file bytes
              final response = await _dio.get<Uint8List>(
                fileUrl,
                options: Options(responseType: ResponseType.bytes),
              );

              if (response.statusCode == 200 && response.data != null) {
                _openCVViewer(Uint8List.fromList(response.data!));
              } else {
                throw Exception('Failed to download file');
              }
            }
          } catch (e) {
            if (mounted) {
              setState(() => _isDownloading = false);
              _showSnackBar('Failed to open CV: $e');
            }
          }
        },
      );
    } catch (e) {
      _showSnackBar('Error opening CV: $e');
    }
  }

  void _openCVViewer(Uint8List fileBytes) {
    if (!mounted) return;

    // Store the file bytes for later use
    _currentFileBytes = fileBytes;

    // For web, use an embedded PDF viewer
    if (kIsWeb) {
      _showWebPDFViewer(fileBytes, widget.cvFile?.fileName ?? 'document.pdf');
    } else {
      // For mobile, use the existing CVViewerPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CVViewerPage(
            fileBytes: fileBytes,
            fileName: widget.cvFile?.fileName,
          ),
        ),
      );
    }
  }

  void _showWebPDFViewer(Uint8List fileBytes, String fileName) {
    // Create a blob URL for the PDF
    final blob = html.Blob([fileBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Register the platform view
    if (kIsWeb) {
      // Use platformViewRegistry on web only
      platform_registry.registerViewFactory('pdf-viewer-$url', (int viewId) {
        final iframe = html.IFrameElement();
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        iframe.src = url;
        return iframe;
      });
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              children: [
                AppBar(
                  title: Text(fileName),
                  backgroundColor: const Color(0xFF7BBFB3),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        _downloadFileWeb(fileBytes, fileName);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                        html.Url.revokeObjectUrl(url);
                      },
                    ),
                  ],
                ),
                Expanded(child: HtmlElementView(viewType: 'pdf-viewer-$url')),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      // Clean up the URL when the dialog is closed
      html.Url.revokeObjectUrl(url);
    });
  }

  void _downloadFileWeb(Uint8List bytes, String fileName) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
