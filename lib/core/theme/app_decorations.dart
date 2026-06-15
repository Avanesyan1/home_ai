import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_spacing.dart';

abstract final class AppDecorations {
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 18,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> cardShadowSoft = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> cardShadowSelected = [
    BoxShadow(
      color: Color(0x2E000000),
      blurRadius: 22,
      offset: Offset(0, 10),
    ),
  ];

  static BoxDecoration surfaceCard({
    bool selected = false,
    double radius = AppSpacing.radiusLg,
  }) {
    return BoxDecoration(
      color: selected ? AppColors.surfaceMuted : AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: selected ? cardShadowSelected : cardShadowSoft,
    );
  }

  static BoxDecoration imageCard({
    bool selected = false,
    double radius = AppSpacing.radiusLg,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      boxShadow: selected ? cardShadowSelected : cardShadow,
    );
  }
}
