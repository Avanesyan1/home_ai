import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/theme/app_animations.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_decorations.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/features/redesign/domain/entities/design_style.dart';
import 'package:home_ai/features/redesign/domain/entities/redesign_category.dart';

class RedesignStyleStep extends StatelessWidget {
  const RedesignStyleStep({
    super.key,
    required this.category,
    required this.styles,
    required this.selectedStyle,
    required this.onStyleSelected,
  });

  final RedesignCategory category;
  final List<DesignStyle> styles;
  final DesignStyle? selectedStyle;
  final ValueChanged<DesignStyle> onStyleSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      children: [
        Text(
          (category == RedesignCategory.floor
                  ? LocaleKeys.redesignStepStyleTitleFloor
                  : LocaleKeys.redesignStepStyleTitle)
              .tr(),
          style: AppTextStyles.title,
        ).animateFadeUp(),
        const SizedBox(height: AppSpacing.sm),
        Text(
          (category == RedesignCategory.floor
                  ? LocaleKeys.redesignStepStyleHintFloor
                  : LocaleKeys.redesignStepStyleHint)
              .tr(),
          style: AppTextStyles.body,
        ).animateFadeUp(delay: const Duration(milliseconds: 60)),
        const SizedBox(height: AppSpacing.lg),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.72,
          ),
          itemCount: styles.length,
          itemBuilder: (context, index) {
            final style = styles[index];
            return _StyleCard(
              style: style,
              isSelected: selectedStyle?.id == style.id,
              onTap: () => onStyleSelected(style),
            ).animateStagger(index, stepMs: 55);
          },
        ),
      ],
    );
  }
}

class _StyleCard extends StatelessWidget {
  const _StyleCard({
    required this.style,
    required this.isSelected,
    required this.onTap,
  });

  final DesignStyle style;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.02 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: AppDecorations.imageCard(
            selected: isSelected,
            radius: AppSpacing.radiusLg,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    style.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const ColoredBox(
                        color: AppColors.imagePlaceholder,
                        child: Center(
                          child: Icon(
                            CupertinoIcons.photo,
                            size: 32,
                            color: AppColors.imagePlaceholderIcon,
                          ),
                        ),
                      );
                    },
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0x00000000),
                          const Color(0x66000000),
                          const Color(0xCC000000),
                        ],
                        stops: const [0.45, 0.75, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    bottom: AppSpacing.md,
                    child: Text(
                      style.label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: AppSpacing.md,
                      right: AppSpacing.md,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.checkmark_alt,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
