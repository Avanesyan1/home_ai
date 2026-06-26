import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class GeneratedDesigns extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get category => text()();

  TextColumn get beforePath => text()();

  TextColumn get afterPath => text()();

  TextColumn get styleId => text()();

  TextColumn get paletteId => text()();

  TextColumn get wishes => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime()();

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [GeneratedDesigns])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(
              generatedDesigns,
              generatedDesigns.isFavorite,
            );
          }
        },
      );

  static AppDatabase? _instance;

  static AppDatabase get instance {
    final database = _instance;
    if (database == null) {
      throw StateError('AppDatabase.initialize() must be called before use.');
    }
    return database;
  }

  static Future<void> initialize() async {
    _instance = AppDatabase();
  }

  Stream<List<GeneratedDesign>> watchAllDesigns({bool favoritesOnly = false}) {
    final query = select(generatedDesigns)
      ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]);

    if (favoritesOnly) {
      query.where((table) => table.isFavorite.equals(true));
    }

    return query.watch();
  }

  Future<void> setFavorite(int id, bool isFavorite) {
    return (update(generatedDesigns)..where((table) => table.id.equals(id)))
        .write(GeneratedDesignsCompanion(isFavorite: Value(isFavorite)));
  }

  Future<int> insertDesign(GeneratedDesignsCompanion entry) {
    return into(generatedDesigns).insert(entry);
  }

  Future<GeneratedDesign?> getDesign(int id) {
    return (select(generatedDesigns)..where((table) => table.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> deleteDesign(int id) {
    return (delete(generatedDesigns)..where((table) => table.id.equals(id)))
        .go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'home_ai.sqlite'));
    return NativeDatabase(file);
  });
}
