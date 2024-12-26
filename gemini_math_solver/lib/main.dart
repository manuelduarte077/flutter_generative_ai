import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gemini_math_solver/api.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  Gemini.init(apiKey: apiKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Math Solving App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? imageQuestion;
  String? answer;
  bool isLoading = false;

  void selectImageFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    await processImage(image);
  }

  void takePhoto() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    await processImage(image);
  }

  Future<void> processImage(XFile? image) async {
    if (image == null) return;

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    setState(() {
      imageQuestion = XFile(croppedFile?.path ?? '');
      isLoading = true;
    });

    final gemini = Gemini.instance;

    gemini.prompt(
      parts: [
        Part.text('Please solve the following mathematical equation:'),
        Part.uint8List(await imageQuestion!.readAsBytes())
      ],
    ).then((value) {
      setState(() {
        answer = value?.output ?? '';
        isLoading = false;
      });
    }).catchError((e) {
      log('textAndImageInput', error: e);
      setState(() {
        answer = 'Error: ${e.toString()}';
        isLoading = false;
      });
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b1c1c),
      appBar: AppBar(
        backgroundColor: const Color(0xff1b1c1c),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        spacing: 20,
        children: [
          Container(
            alignment: Alignment.center,
            height: imageQuestion == null ? 300 : null,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Color(0xff242c2c)),
            child: imageQuestion == null
                ? const Text(
                    'No Image Selected',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )
                : Image.file(
                    File(imageQuestion!.path),
                    fit: BoxFit.fill,
                  ),
          ),

          // Select Image Button
          FilledButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Select Image from Gallery'),
                          onTap: () {
                            Navigator.pop(context);
                            selectImageFromGallery();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Take Photo'),
                          onTap: () {
                            Navigator.pop(context);
                            takePhoto();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Text(
              'Select Image',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          isLoading == false && answer == null
              ? const SizedBox.shrink()
              : isLoading != false
                  ? const CircularProgressIndicator(
                      color: Colors.blue,
                    )
                  : Text(
                      answer ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.start,
                    )
        ],
      ),
    );
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
