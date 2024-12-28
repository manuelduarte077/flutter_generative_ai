import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:generate_meme/constants/api_constants.dart';

class MemeViewModel extends ChangeNotifier {
  XFile? selectedImage;
  String? generatedText;
  bool isLoading = false;
  String? error;

  final ImagePicker _picker = ImagePicker();

  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: ApiConstants.GEMINI_API_KEY,
  );

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        selectedImage = image;
        notifyListeners();
      }
    } catch (e) {
      error = 'Failed to pick image: $e';
      notifyListeners();
    }
  }

  Future<void> generateMemeText(String prompt) async {
    if (selectedImage == null) {
      error = 'Por favor selecciona una imagen primero';
      notifyListeners();
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final content = [
        Content.text(
            'Genera un texto gracioso para un meme en español basado en el siguiente prompt: $prompt. El texto debe ser corto, ingenioso y en español.')
      ];

      final response = await model.generateContent(content);
      generatedText = response.text;
    } catch (e) {
      error = 'Error al generar el texto del meme: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    selectedImage = null;
    generatedText = null;
    error = null;
    notifyListeners();
  }
}
