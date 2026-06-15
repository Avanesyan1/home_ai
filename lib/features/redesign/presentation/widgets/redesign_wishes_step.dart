import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/theme/app_decorations.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';

class RedesignWishesStep extends StatelessWidget {
  const RedesignWishesStep({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      children: [
        Text(
          LocaleKeys.redesignStepWishesTitle.tr(),
          style: AppTextStyles.title,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          LocaleKeys.redesignStepWishesHint.tr(),
          style: AppTextStyles.body,
        ),
        const SizedBox(height: AppSpacing.lg),
        CupertinoTextField(
          controller: controller,
          maxLines: 6,
          minLines: 4,
          placeholder: LocaleKeys.redesignWishesPlaceholder.tr(),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: AppDecorations.surfaceCard(radius: AppSpacing.radiusMd),
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
