import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:generate_meme/viewmodels/meme_viewmodel.dart';
import 'package:generate_meme/views/home_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MemeViewModel()),
      ],
      child: CupertinoApp(
        title: 'Meme Generator',
        theme: CupertinoThemeData(
          primaryColor: CupertinoColors.systemOrange,
        ),
        home: const HomeView(),
      ),
    );
  }
}
