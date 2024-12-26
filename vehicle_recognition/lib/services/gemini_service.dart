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
      const prompt =
          '''Analyze this car image and provide information SPECIFIC TO THE NICARAGUAN MARKET in the following format:
Make: [make]
Model: [model]
Year: [estimated year or year range]
Price Range: [price range in USD and NIO (Nicaraguan Córdobas)]
Available at: [list of official dealers or main used car dealers in Nicaragua]
Market Notes: [1-2 lines about availability and popularity in Nicaragua]
Common Uses in Nicaragua: [brief note about typical usage]''';

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

  Future<String> recommendCar(
      String preferences, double budget, String category) async {
    try {
      final prompt =
          '''As a car expert in Nicaragua, provide a car recommendation that's readily available in the Nicaraguan market, using this format ONLY:

Vehicle: [make, model, year]
Price: [current price range in USD and equivalent in NIO (Nicaraguan Córdobas)]
Availability: [where to find this car in Nicaragua]
Match Score: [why this car matches the requirements considering Nicaraguan roads and conditions]
Key Features: [3-4 most relevant features for Nicaragua]
Local Market Notes: [1-2 lines about reputation and resale value in Nicaragua]

Based on:
- Preferences: $preferences
- Budget: \$$budget (${(budget * 36.5).toStringAsFixed(2)} NIO)
- Category: $category
- Market: Nicaragua''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      return response.text ?? 'Failed to recommend car';
    } catch (e) {
      return 'Error recommending car: $e';
    }
  }
}
