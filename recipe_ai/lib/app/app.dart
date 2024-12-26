import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../database/database.dart';
import '../providers/database_provider.dart';
import '../screens/home_screen.dart';
import '../screens/favorites_screen.dart';

class MyApp extends StatelessWidget {
  final database = AppDatabase();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DatabaseProvider(
      database: database,
      child: MaterialApp(
        debugShowCheckedModeBanner: kDebugMode ? true : false,
        title: 'Recipe Generator',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/favorites': (context) => const FavoritesScreen(),
        },
      ),
    );
  }
}
