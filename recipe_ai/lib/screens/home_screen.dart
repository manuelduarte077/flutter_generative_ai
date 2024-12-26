import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../services/gemini_service.dart';
import '../providers/database_provider.dart';
import '../widgets/cooking_timer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _ingredientsController = TextEditingController();
  final _geminiService = GeminiService();
  final _imagePicker = ImagePicker();

  String? _recipe;
  bool _isLoading = false;
  File? _selectedImage;

  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Vegetarian',
    'Healthy',
  ];

  bool _isCurrentRecipeFavorite = false;

  Future<void> _checkFavoriteStatus() async {
    if (_recipe != null) {
      final isFavorite =
          await DatabaseProvider.of(context).database.isFavorite(_recipe!);

      setState(() {
        _isCurrentRecipeFavorite = isFavorite;
      });
    }
  }

  /// Web implementation

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.green,
              ),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: Colors.green,
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(source: source);
      if (image == null) return;

      setState(() {
        _selectedImage = File(image.path);
        _isLoading = true;
      });

      final ingredients =
          await _geminiService.identifyIngredientsFromImage(_selectedImage!);

      setState(() {
        _isLoading = false;
        _ingredientsController.text = ingredients;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to process image: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade400,
      ),
    );
  }

  Future<void> _generateRecipe() async {
    if (_ingredientsController.text.isEmpty) {
      _showError('Please enter some ingredients first');
      return;
    }

    setState(() {
      _isLoading = true;
      _recipe = null;
      _isCurrentRecipeFavorite = false;
    });

    try {
      final recipe = await _geminiService.generateRecipe(
        _ingredientsController.text,
        category: _selectedCategory == 'All' ? null : _selectedCategory,
      );

      setState(() {
        _recipe = recipe;
        _isLoading = false;
      });

      _checkFavoriteStatus();
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to generate recipe: $e');
    }
  }

  String _extractCookingTime(String recipe) {
    final cookingTimeMatch = RegExp(r'Cooking Time:(.*?)\n').firstMatch(recipe);
    return cookingTimeMatch?.group(1)?.trim() ?? '0 minutes';
  }

  @override
  void dispose() {
    _ingredientsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Generator'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 24,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildImageSection(),
                    _buildIngredientsInput(),
                    _buildCategorySelector(),
                    _buildGenerateButton(),
                    Expanded(child: _buildRecipeDisplay()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: _isLoading ? null : _showImageSourceDialog,
          icon: const Icon(Icons.add_a_photo),
          label: const Text('Add Ingredients Photo'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(16),
          ),
        ),
        if (_selectedImage != null) ...[
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Image.file(
                  _selectedImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                IconButton(
                  onPressed: () => setState(() => _selectedImage = null),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIngredientsInput() {
    return TextField(
      controller: _ingredientsController,
      decoration: InputDecoration(
        labelText: 'Ingredients',
        hintText: 'Enter ingredients or add a photo',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.restaurant),
        suffixIcon: _ingredientsController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _ingredientsController.clear();
                  setState(() {
                    _selectedImage = null;
                    _recipe = null;
                  });
                },
              )
            : null,
      ),
      maxLines: 3,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _generateRecipe(),
    );
  }

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((category) {
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(category),
              onSelected: (_) => setState(
                () => _selectedCategory = category,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return FilledButton.icon(
      onPressed: _isLoading ? null : _generateRecipe,
      icon: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.restaurant_menu),
      label: Text(_isLoading ? 'Generating...' : 'Generate Recipe'),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildRecipeDisplay() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Preparing your recipe...'),
          ],
        ),
      );
    }

    if (_recipe == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Add ingredients to generate a recipe',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recipe',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isCurrentRecipeFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: _isCurrentRecipeFavorite ? Colors.red : null,
                  ),
                  onPressed: () async {
                    final db = DatabaseProvider.of(context).database;

                    setState(() {
                      _isCurrentRecipeFavorite = !_isCurrentRecipeFavorite;
                    });

                    try {
                      if (_isCurrentRecipeFavorite) {
                        await db.addFavorite('Recipe', _recipe ?? '');
                      } else {
                        await db.removeFavorite(_recipe ?? '');
                      }
                    } catch (e) {
                      setState(() {
                        _isCurrentRecipeFavorite = !_isCurrentRecipeFavorite;
                      });
                      _showError('Failed to update favorite status');
                    }
                  },
                ),
              ],
            ),

            /// Cooking timer
            if (_recipe != null) ...[
              const SizedBox(height: 16),
              CookingTimer(cookingTime: _extractCookingTime(_recipe!)),
              const SizedBox(height: 16),
            ],
            Text(
              'Ingredients: ${_ingredientsController.text}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// Recipe
            ..._recipe!.split('\n').map(
                  (line) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      line,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: line.endsWith(':')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),

            /// Share button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Share.share(
                    'Check out this recipe!\n\n'
                    '${_recipe!}',
                    subject: 'Recipe Share',
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
