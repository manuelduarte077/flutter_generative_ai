import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:generate_meme/viewmodels/meme_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Meme Generator',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      child: SafeArea(
        child: Consumer<MemeViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 16,
                  children: [
                    /// Selected image
                    if (viewModel.selectedImage != null)
                      SizedBox(
                        height: 200,
                        child: Image.file(
                          File(viewModel.selectedImage!.path),
                          fit: BoxFit.contain,
                        ),
                      ),

                    /// Select image
                    CupertinoButton.filled(
                      onPressed: viewModel.pickImage,
                      child: const Text(
                        'Select Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    /// Prompt
                    CupertinoTextField(
                      placeholder: 'Enter your meme idea...',
                      onSubmitted: (value) => viewModel.generateMemeText(value),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                    ),

                    /// Loading
                    if (viewModel.isLoading)
                      const Center(child: CupertinoActivityIndicator()),

                    /// Generated text
                    if (viewModel.generatedText != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          viewModel.generatedText!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    /// Error
                    if (viewModel.error != null)
                      Text(
                        viewModel.error!,
                        style: const TextStyle(
                          color: CupertinoColors.systemRed,
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
