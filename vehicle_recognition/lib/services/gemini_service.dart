import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  late final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: dotenv.env['GEMINI_API_KEY']!,
    safetySettings: [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
    ],
  );

  Future<String> identifyCarFromImage(File imageFile) async {
    try {
      final imageData = await imageFile.readAsBytes();
      const prompt = '''Identify the make and model of the car in this image.
Provide the information in a clear format, specifying:
- Make
- Model 
- Year (if possible)
- Estimated price range in Nicaragua
- Official distributors/dealerships in Nicaragua where this model can be purchased
- Any additional relevant information about availability in the Nicaraguan market''';

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/', imageData),
        ])
      ];

      final response = await model.generateContent(content);
      return response.text ?? 'No car identified';
    } catch (e) {
      return 'Error analyzing image: $e';
    }
  }

  Future<String> recommendCar(String preferences, double budget) async {
    try {
      final prompt =
          '''Based on the following preferences: $preferences and a budget of \$$budget, recommend a car.
Please provide the make, model, year, and a brief description of why this car fits the preferences and budget.''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      return response.text ?? 'Failed to recommend a car';
    } catch (e) {
      return 'Error recommending car: $e';
    }
  }
}
