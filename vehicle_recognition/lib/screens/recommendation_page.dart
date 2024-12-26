import 'package:flutter/cupertino.dart';
import '../services/gemini_service.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  final _geminiService = GeminiService();
  final _preferencesController = TextEditingController();
  final _budgetController = TextEditingController();
  String _recommendation = '';
  bool _isLoading = false;

  final List<String> categories = [
    'New Cars',
    'Used Cars',
    'Electric Vehicles',
    'Hybrid'
  ];
  String _selectedCategory = 'New Cars';

  Future<void> _getRecommendation() async {
    if (_preferencesController.text.isEmpty || _budgetController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _recommendation = '';
    });

    try {
      final budget = double.parse(_budgetController.text);
      final result = await _geminiService.recommendCar(
        _preferencesController.text,
        budget,
        _selectedCategory,
      );
      setState(() {
        _recommendation = result;
      });
    } catch (e) {
      setState(() {
        _recommendation = 'Error getting recommendation: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _preferencesController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Car Recommendations'),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// Description
                  Text(
                    'Find the perfect car for your needs in Nicaragua. Enter your preferences and budget to get started.',
                    style: TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.label,
                    ),
                  ),

                  /// Category
                  CupertinoPicker(
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedCategory = categories[index];
                      });
                    },
                    children: categories
                        .map((category) => Center(
                              child: Text(
                                category,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.label,
                                ),
                              ),
                            ))
                        .toList(),
                  ),

                  /// Preferences
                  CupertinoTextField(
                    controller: _preferencesController,
                    placeholder:
                        'Enter your preferences (e.g., SUV, fuel efficient, family car)',
                    padding: const EdgeInsets.all(12),
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    controller: _budgetController,
                    placeholder: 'Enter your budget in USD',
                    padding: const EdgeInsets.all(12),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 24),
                  CupertinoButton.filled(
                    onPressed: _getRecommendation,
                    child: const Text('Get Recommendation'),
                  ),
                  const SizedBox(height: 24),
                  if (_isLoading)
                    const Center(child: CupertinoActivityIndicator())
                  else if (_recommendation.isNotEmpty)
                    Text(
                      _recommendation,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
