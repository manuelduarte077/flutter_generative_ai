import 'package:flutter/cupertino.dart';
import '../screens/recognition_page.dart';
import '../screens/recommendation_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.car_detailed, size: 24),
              label: 'Recognition',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search, size: 24),
              label: 'Recommend',
            ),
          ],
        ),
        tabBuilder: (context, index) {
          return index == 0
              ? const RecognitionPage(title: 'Vehicle Recognition')
              : const RecommendationPage();
        },
      ),
    );
  }
}
