import 'package:flutter/material.dart';
import '../database/database.dart';

class DatabaseProvider extends InheritedWidget {
  final AppDatabase database;

  const DatabaseProvider({
    super.key,
    required this.database,
    required super.child,
  });

  static DatabaseProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DatabaseProvider>()!;
  }

  @override
  bool updateShouldNotify(DatabaseProvider oldWidget) => false;
}
