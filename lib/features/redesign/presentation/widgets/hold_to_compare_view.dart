import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_decorations.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';

class HoldToCompareView extends StatefulWidget {
  const HoldToCompareView({
    super.key,
    required this.beforePath,
    required this.afterPath,
  });

  final String beforePath;
  final String afterPath;

  @override
  State<HoldToCompareView> createState() => _HoldToCompareViewState();
}

class _HoldToCompareViewState extends State<HoldToCompareView> {
  bool _showingBefore = false;

  void _setShowingBefore(bool value) {
    if (_showingBefore != value) {
      setState(() => _showingBefore = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _showingBefore ? widget.beforePath : widget.afterPath;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: GestureDetector(
            onLongPressStart: (_) => _setShowingBefore(true),
            onLongPressEnd: (_) => _setShowingBefore(false),
            onLongPressCancel: () => _setShowingBefore(false),
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: AppDecorations.imageCard(
                    radius: AppSpacing.radiusLg,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                if (_showingBefore)
                  Positioned(
                    top: AppSpacing.md,
                    left: AppSpacing.md,
                    child: _Badge(
                      label: LocaleKeys.redesignBefore.tr(),
                    ),
                  ),
                if (!_showingBefore)
                  Positioned(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    bottom: AppSpacing.md,
                    child: _HintBubble(
                      text: LocaleKeys.redesignHoldToCompareHint.tr(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.surface),
        ),
      ),
    );
  }
}

class _HintBubble extends StatelessWidget {
  const _HintBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.hand_draw,
              color: AppColors.surface,
              size: 18,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.surface,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
