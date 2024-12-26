import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../apikey_widget.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RecognitionPage(
        title: 'Vehicle Recognition',
      ),
    );
  }
}

class RecognitionPage extends StatefulWidget {
  const RecognitionPage({super.key, required this.title});

  final String title;

  @override
  State<RecognitionPage> createState() => _RecognitionPageState();
}

class _RecognitionPageState extends State<RecognitionPage> {
  @override
  Widget build(BuildContext context) {
    String? apiKey;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: switch (apiKey) {
        final providedKey? => SelectImage(apiKey: providedKey),
        _ => ApiKeyWidget(onSubmitted: (key) {
            setState(() => apiKey = key);
          }),
      },
    );
  }
}

class SelectImage extends StatefulWidget {
  const SelectImage({
    super.key,
    required this.apiKey,
  });

  final String apiKey;

  @override
  State<SelectImage> createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  late final GenerativeModel _model;
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: widget.apiKey,
    );
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, index) => Text('Item $index'),
          ),
        ),
      ],
    );
  }
}
