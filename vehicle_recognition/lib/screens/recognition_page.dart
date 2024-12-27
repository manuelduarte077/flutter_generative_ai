import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../services/gemini_service.dart';

class RecognitionPage extends StatefulWidget {
  const RecognitionPage({super.key, required this.title});

  final String title;

  @override
  State<RecognitionPage> createState() => _RecognitionPageState();
}

class _RecognitionPageState extends State<RecognitionPage> {
  File? _selectedImage;
  String _recognitionResult = '';
  bool _isLoading = false;

  final _geminiService = GeminiService();
  final _imagePicker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _recognitionResult = '';
        });
        await _identifyCar();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _identifyCar() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _geminiService.identifyCarFromImage(_selectedImage!);
      setState(() {
        _recognitionResult = result;
      });
    } catch (e) {
      setState(() {
        _recognitionResult = 'Error analyzing image: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            leading: Icon(CupertinoIcons.car),
            largeTitle: Text(
              'Car Recognition',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(CupertinoIcons.camera),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_selectedImage != null) ...[
                    Flexible(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],

                  /// Loading
                  if (_isLoading)
                    const Center(child: CupertinoActivityIndicator())
                  else if (_recognitionResult.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _recognitionResult,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  /// showModalBottomSheet
                  CupertinoButton.filled(
                    borderRadius: BorderRadius.circular(16),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return CupertinoActionSheet(
                            title: const Text(
                              'Select Image Source',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            message: const Text(
                              'Select the source of the image you want to recognize',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  _pickImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Camera',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  _pickImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Gallery',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Recognize',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: CupertinoColors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          CupertinoIcons.camera,
                          size: 24,
                          color: CupertinoColors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
