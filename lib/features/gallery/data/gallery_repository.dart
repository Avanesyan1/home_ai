import 'dart:io';

import 'package:drift/drift.dart';
import 'package:home_ai/core/database/app_database.dart';
import 'package:home_ai/features/gallery/domain/entities/saved_design.dart';
import 'package:home_ai/features/redesign/domain/entities/redesign_category.dart';

class GalleryRepository {
  GalleryRepository(this._database);

  final AppDatabase _database;

  static GalleryRepository? _instance;

  static GalleryRepository get instance {
    final repository = _instance;
    if (repository == null) {
      throw StateError('GalleryRepository.initialize() must be called first.');
    }
    return repository;
  }

  static void initialize(AppDatabase database) {
    _instance = GalleryRepository(database);
  }

  Stream<List<SavedDesign>> watchAll({bool favoritesOnly = false}) {
    return _database.watchAllDesigns(favoritesOnly: favoritesOnly).map(
          (rows) => rows.map(SavedDesign.fromRow).toList(growable: false),
        );
  }

  Future<void> toggleFavorite(int id, bool isFavorite) {
    return _database.setFavorite(id, isFavorite);
  }

  Future<SavedDesign?> getById(int id) async {
    final row = await _database.getDesign(id);
    return row == null ? null : SavedDesign.fromRow(row);
  }

  Future<int> save({
    required RedesignCategory category,
    required String beforePath,
    required String afterPath,
    required String styleId,
    required String paletteId,
    String wishes = '',
  }) {
    return _database.insertDesign(
      GeneratedDesignsCompanion.insert(
        category: category.name,
        beforePath: beforePath,
        afterPath: afterPath,
        styleId: styleId,
        paletteId: paletteId,
        wishes: Value(wishes),
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> delete(int id) async {
    final design = await getById(id);
    if (design == null) {
      return;
    }

    await _deleteFileIfExists(design.beforePath);
    await _deleteFileIfExists(design.afterPath);
    await _database.deleteDesign(id);
  }

  Future<void> _deleteFileIfExists(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
