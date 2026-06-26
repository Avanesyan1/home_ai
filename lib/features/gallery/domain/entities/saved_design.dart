import 'package:home_ai/core/database/app_database.dart';
import 'package:home_ai/features/redesign/domain/entities/redesign_category.dart';

class SavedDesign {
  const SavedDesign({
    required this.id,
    required this.category,
    required this.beforePath,
    required this.afterPath,
    required this.styleId,
    required this.paletteId,
    required this.wishes,
    required this.createdAt,
    this.isFavorite = false,
  });

  final int id;
  final RedesignCategory category;
  final String beforePath;
  final String afterPath;
  final String styleId;
  final String paletteId;
  final String wishes;
  final DateTime createdAt;
  final bool isFavorite;

  factory SavedDesign.fromRow(GeneratedDesign row) {
    return SavedDesign(
      id: row.id,
      category: RedesignCategory.values.byName(row.category),
      beforePath: row.beforePath,
      afterPath: row.afterPath,
      styleId: row.styleId,
      paletteId: row.paletteId,
      wishes: row.wishes,
      createdAt: row.createdAt,
      isFavorite: row.isFavorite,
    );
  }
}
