import 'package:flutter/cupertino.dart';

import '../screens/recognition_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: RecognitionPage(
        title: 'Vehicle Recognition',
      ),
    );
  }
}
