import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_decorations.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/features/redesign/domain/entities/color_palette_option.dart';

class RedesignPaletteStep extends StatelessWidget {
  const RedesignPaletteStep({
    super.key,
    required this.palettes,
    required this.selectedPalette,
    required this.onPaletteSelected,
  });

  final List<ColorPaletteOption> palettes;
  final ColorPaletteOption? selectedPalette;
  final ValueChanged<ColorPaletteOption> onPaletteSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      children: [
        Text(
          LocaleKeys.redesignStepPaletteTitle.tr(),
          style: AppTextStyles.title,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          LocaleKeys.redesignStepPaletteHint.tr(),
          style: AppTextStyles.body,
        ),
        const SizedBox(height: AppSpacing.lg),
        ...palettes.map((palette) {
          final isSelected = selectedPalette?.id == palette.id;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: GestureDetector(
              onTap: () => onPaletteSelected(palette),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: AppDecorations.surfaceCard(selected: isSelected),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        palette.label,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      children: palette.colors.map((color) {
                        return Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(left: AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            boxShadow: AppDecorations.cardShadowSoft,
                          ),
                        );
                      }).toList(),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: AppSpacing.sm),
                      const Icon(
                        CupertinoIcons.checkmark_alt,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
