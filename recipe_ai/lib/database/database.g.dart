// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FavoriteRecipesTable extends FavoriteRecipes
    with TableInfo<$FavoriteRecipesTable, FavoriteRecipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteRecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipeMeta = const VerificationMeta('recipe');
  @override
  late final GeneratedColumn<String> recipe = GeneratedColumn<String>(
      'recipe', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, title, recipe, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_recipes';
  @override
  VerificationContext validateIntegrity(Insertable<FavoriteRecipe> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('recipe')) {
      context.handle(_recipeMeta,
          recipe.isAcceptableOrUnknown(data['recipe']!, _recipeMeta));
    } else if (isInserting) {
      context.missing(_recipeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FavoriteRecipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteRecipe(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      recipe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipe'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FavoriteRecipesTable createAlias(String alias) {
    return $FavoriteRecipesTable(attachedDatabase, alias);
  }
}

class FavoriteRecipe extends DataClass implements Insertable<FavoriteRecipe> {
  final int id;
  final String title;
  final String recipe;
  final DateTime createdAt;
  const FavoriteRecipe(
      {required this.id,
      required this.title,
      required this.recipe,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['recipe'] = Variable<String>(recipe);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FavoriteRecipesCompanion toCompanion(bool nullToAbsent) {
    return FavoriteRecipesCompanion(
      id: Value(id),
      title: Value(title),
      recipe: Value(recipe),
      createdAt: Value(createdAt),
    );
  }

  factory FavoriteRecipe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteRecipe(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      recipe: serializer.fromJson<String>(json['recipe']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'recipe': serializer.toJson<String>(recipe),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FavoriteRecipe copyWith(
          {int? id, String? title, String? recipe, DateTime? createdAt}) =>
      FavoriteRecipe(
        id: id ?? this.id,
        title: title ?? this.title,
        recipe: recipe ?? this.recipe,
        createdAt: createdAt ?? this.createdAt,
      );
  FavoriteRecipe copyWithCompanion(FavoriteRecipesCompanion data) {
    return FavoriteRecipe(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      recipe: data.recipe.present ? data.recipe.value : this.recipe,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteRecipe(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('recipe: $recipe, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, recipe, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteRecipe &&
          other.id == this.id &&
          other.title == this.title &&
          other.recipe == this.recipe &&
          other.createdAt == this.createdAt);
}

class FavoriteRecipesCompanion extends UpdateCompanion<FavoriteRecipe> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> recipe;
  final Value<DateTime> createdAt;
  const FavoriteRecipesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.recipe = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FavoriteRecipesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String recipe,
    this.createdAt = const Value.absent(),
  })  : title = Value(title),
        recipe = Value(recipe);
  static Insertable<FavoriteRecipe> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? recipe,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (recipe != null) 'recipe': recipe,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FavoriteRecipesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? recipe,
      Value<DateTime>? createdAt}) {
    return FavoriteRecipesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      recipe: recipe ?? this.recipe,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (recipe.present) {
      map['recipe'] = Variable<String>(recipe.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteRecipesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('recipe: $recipe, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoriteRecipesTable favoriteRecipes =
      $FavoriteRecipesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [favoriteRecipes];
}

typedef $$FavoriteRecipesTableCreateCompanionBuilder = FavoriteRecipesCompanion
    Function({
  Value<int> id,
  required String title,
  required String recipe,
  Value<DateTime> createdAt,
});
typedef $$FavoriteRecipesTableUpdateCompanionBuilder = FavoriteRecipesCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<String> recipe,
  Value<DateTime> createdAt,
});

class $$FavoriteRecipesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoriteRecipesTable> {
  $$FavoriteRecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipe => $composableBuilder(
      column: $table.recipe, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FavoriteRecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoriteRecipesTable> {
  $$FavoriteRecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipe => $composableBuilder(
      column: $table.recipe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FavoriteRecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoriteRecipesTable> {
  $$FavoriteRecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get recipe =>
      $composableBuilder(column: $table.recipe, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FavoriteRecipesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoriteRecipesTable,
    FavoriteRecipe,
    $$FavoriteRecipesTableFilterComposer,
    $$FavoriteRecipesTableOrderingComposer,
    $$FavoriteRecipesTableAnnotationComposer,
    $$FavoriteRecipesTableCreateCompanionBuilder,
    $$FavoriteRecipesTableUpdateCompanionBuilder,
    (
      FavoriteRecipe,
      BaseReferences<_$AppDatabase, $FavoriteRecipesTable, FavoriteRecipe>
    ),
    FavoriteRecipe,
    PrefetchHooks Function()> {
  $$FavoriteRecipesTableTableManager(
      _$AppDatabase db, $FavoriteRecipesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteRecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteRecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteRecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> recipe = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              FavoriteRecipesCompanion(
            id: id,
            title: title,
            recipe: recipe,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String recipe,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              FavoriteRecipesCompanion.insert(
            id: id,
            title: title,
            recipe: recipe,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoriteRecipesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoriteRecipesTable,
    FavoriteRecipe,
    $$FavoriteRecipesTableFilterComposer,
    $$FavoriteRecipesTableOrderingComposer,
    $$FavoriteRecipesTableAnnotationComposer,
    $$FavoriteRecipesTableCreateCompanionBuilder,
    $$FavoriteRecipesTableUpdateCompanionBuilder,
    (
      FavoriteRecipe,
      BaseReferences<_$AppDatabase, $FavoriteRecipesTable, FavoriteRecipe>
    ),
    FavoriteRecipe,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoriteRecipesTableTableManager get favoriteRecipes =>
      $$FavoriteRecipesTableTableManager(_db, _db.favoriteRecipes);
}
