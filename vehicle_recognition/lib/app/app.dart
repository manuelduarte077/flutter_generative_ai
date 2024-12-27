import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../screens/recognition_page.dart';
import '../screens/recommendation_page.dart';
import '../screens/settings_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return CupertinoApp(
          debugShowCheckedModeBanner: false,
          theme: CupertinoThemeData(
            brightness:
                settings.isDarkMode ? Brightness.dark : Brightness.light,
            primaryContrastingColor: CupertinoColors.systemGreen,
            primaryColor: CupertinoColors.systemGreen,
          ),
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
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.settings, size: 24),
                  label: 'Settings',
                ),
              ],
            ),
            tabBuilder: (context, index) {
              switch (index) {
                case 0:
                  return const RecognitionPage(title: 'Recognition');
                case 1:
                  return const RecommendationPage();
                case 2:
                  return const SettingsPage();
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        );
      },
    );
  }
}
