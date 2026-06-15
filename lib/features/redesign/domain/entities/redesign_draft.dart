import 'package:home_ai/features/redesign/domain/entities/color_palette_option.dart';
import 'package:home_ai/features/redesign/domain/entities/design_style.dart';
import 'package:home_ai/features/redesign/domain/entities/redesign_category.dart';

class RedesignDraft {
  const RedesignDraft({
    required this.category,
    this.imagePath,
    this.style,
    this.palette,
    this.wishes = '',
  });

  final RedesignCategory category;
  final String? imagePath;
  final DesignStyle? style;
  final ColorPaletteOption? palette;
  final String wishes;

  RedesignDraft copyWith({
    String? imagePath,
    DesignStyle? style,
    ColorPaletteOption? palette,
    String? wishes,
  }) {
    return RedesignDraft(
      category: category,
      imagePath: imagePath ?? this.imagePath,
      style: style ?? this.style,
      palette: palette ?? this.palette,
      wishes: wishes ?? this.wishes,
    );
  }

  bool get isReadyToGenerate =>
      imagePath != null && style != null && palette != null;
}
