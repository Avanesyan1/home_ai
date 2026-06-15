import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/config/app_assets.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/features/redesign/domain/entities/color_palette_option.dart';
import 'package:home_ai/features/redesign/domain/entities/design_style.dart';
import 'package:home_ai/features/redesign/domain/entities/redesign_category.dart';

abstract final class RedesignOptions {
  static const palettes = [
    ColorPaletteOption(
      id: 'neutral',
      labelKey: LocaleKeys.redesignPaletteNeutral,
      colors: [
        Color(0xFFF5F5F5),
        Color(0xFFE0E0E0),
        Color(0xFF9E9E9E),
        Color(0xFF616161),
        Color(0xFF000000),
      ],
    ),
    ColorPaletteOption(
      id: 'warm',
      labelKey: LocaleKeys.redesignPaletteWarm,
      colors: [
        Color(0xFFFFF3E8),
        Color(0xFFE8C4A8),
        Color(0xFFC9956C),
        Color(0xFF8B5E3C),
        Color(0xFF3D2314),
      ],
    ),
    ColorPaletteOption(
      id: 'cool',
      labelKey: LocaleKeys.redesignPaletteCool,
      colors: [
        Color(0xFFE8F4F8),
        Color(0xFFB8D4E3),
        Color(0xFF7BA7BC),
        Color(0xFF4A7285),
        Color(0xFF1F3A47),
      ],
    ),
    ColorPaletteOption(
      id: 'monochrome',
      labelKey: LocaleKeys.redesignPaletteMonochrome,
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFCCCCCC),
        Color(0xFF888888),
        Color(0xFF444444),
        Color(0xFF000000),
      ],
    ),
    ColorPaletteOption(
      id: 'natural',
      labelKey: LocaleKeys.redesignPaletteNatural,
      colors: [
        Color(0xFFF2EDE4),
        Color(0xFFD4C4A8),
        Color(0xFF9A8B6E),
        Color(0xFF5C6B4A),
        Color(0xFF2E3D24),
      ],
    ),
  ];

  static List<DesignStyle> stylesFor(RedesignCategory category) {
    return switch (category) {
      RedesignCategory.interior => _interiorStyles,
      RedesignCategory.exterior => _exteriorStyles,
      RedesignCategory.garden => _gardenStyles,
      RedesignCategory.floor => _floorStyles,
    };
  }

  static DesignStyle _style(
    RedesignCategory category,
    String id,
    String labelKey, {
    String extension = 'jpeg',
  }) {
    return DesignStyle(
      id: id,
      labelKey: labelKey,
      imagePath: AppAssets.styleImage(
        category: category,
        styleId: id,
        extension: extension,
      ),
    );
  }

  static final _interiorStyles = [
    _style(RedesignCategory.interior, 'modern', LocaleKeys.redesignStyleModern),
    _style(
      RedesignCategory.interior,
      'minimalist',
      LocaleKeys.redesignStyleMinimalist,
    ),
    _style(
      RedesignCategory.interior,
      'scandinavian',
      LocaleKeys.redesignStyleScandinavian,
    ),
    _style(
      RedesignCategory.interior,
      'industrial',
      LocaleKeys.redesignStyleIndustrial,
    ),
    _style(
      RedesignCategory.interior,
      'classic',
      LocaleKeys.redesignStyleClassic,
    ),
    _style(RedesignCategory.interior, 'luxury', LocaleKeys.redesignStyleLuxury),
  ];

  static final _exteriorStyles = [
    _style(RedesignCategory.exterior, 'modern', LocaleKeys.redesignStyleModern),
    _style(
      RedesignCategory.exterior,
      'minimalist',
      LocaleKeys.redesignStyleMinimalist,
    ),
    _style(
      RedesignCategory.exterior,
      'mediterranean',
      LocaleKeys.redesignStyleMediterranean,
    ),
    _style(
      RedesignCategory.exterior,
      'classic',
      LocaleKeys.redesignStyleClassic,
    ),
    _style(RedesignCategory.exterior, 'rustic', LocaleKeys.redesignStyleRustic),
    _style(
      RedesignCategory.exterior,
      'contemporary',
      LocaleKeys.redesignStyleContemporary,
    ),
  ];

  static final _gardenStyles = [
    _style(RedesignCategory.garden, 'modern', LocaleKeys.redesignStyleModern),
    _style(RedesignCategory.garden, 'zen', LocaleKeys.redesignStyleZen),
    _style(RedesignCategory.garden, 'tropical', LocaleKeys.redesignStyleTropical),
    _style(RedesignCategory.garden, 'english', LocaleKeys.redesignStyleEnglish),
    _style(
      RedesignCategory.garden,
      'minimalist',
      LocaleKeys.redesignStyleMinimalist,
    ),
    _style(RedesignCategory.garden, 'natural', LocaleKeys.redesignStyleNatural),
  ];

  static final _floorStyles = [
    _style(RedesignCategory.floor, 'hardwood', LocaleKeys.redesignStyleHardwood),
    _style(RedesignCategory.floor, 'laminate', LocaleKeys.redesignStyleLaminate),
    _style(RedesignCategory.floor, 'tile', LocaleKeys.redesignStyleTile),
    _style(RedesignCategory.floor, 'marble', LocaleKeys.redesignStyleMarble),
    _style(RedesignCategory.floor, 'concrete', LocaleKeys.redesignStyleConcrete),
    _style(RedesignCategory.floor, 'carpet', LocaleKeys.redesignStyleCarpet),
  ];
}
