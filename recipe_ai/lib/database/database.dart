import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'database.g.dart';

class FavoriteRecipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get recipe => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [FavoriteRecipes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<FavoriteRecipe>> getAllFavorites() =>
      select(favoriteRecipes).get();

  Future<bool> isFavorite(String recipe) async {
    final count = await (select(favoriteRecipes)
          ..where((tbl) => tbl.recipe.equals(recipe)))
        .get();
    return count.isNotEmpty;
  }

  Future<int> addFavorite(String title, String recipe) {
    return into(favoriteRecipes).insert(
      FavoriteRecipesCompanion.insert(
        title: title,
        recipe: recipe,
      ),
    );
  }

  Future<int> removeFavorite(String recipe) {
    return (delete(favoriteRecipes)..where((tbl) => tbl.recipe.equals(recipe)))
        .go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'recipes.sqlite'));

    if (Platform.isAndroid) {
      return NativeDatabase.createInBackground(file);
    }

    return NativeDatabase.createInBackground(file);
  });
}
