import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/app_locales.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/l10n/locale_labels.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';

abstract final class LanguagePickerSheet {
  static void show(BuildContext context) {
    final currentLocale = context.locale;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => Container(
        margin: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.md),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  LocaleKeys.settingsLanguage.tr(),
                  style: AppTextStyles.title,
                ),
              ),
              for (var i = 0; i < AppLocales.supported.length; i++)
                _LanguageOption(
                  label: AppLocales.supported[i].label,
                  isSelected: AppLocales.supported[i].languageCode ==
                      currentLocale.languageCode,
                  showDivider: i < AppLocales.supported.length - 1,
                  onTap: () {
                    context.setLocale(AppLocales.supported[i]);
                    Navigator.of(sheetContext).pop();
                  },
                ),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    child: Text(
                      LocaleKeys.commonCancel.tr(),
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.showDivider,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoButton(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          onPressed: onTap,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  color: AppColors.primary,
                  size: 22,
                ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Container(height: 1, color: AppColors.divider),
          ),
      ],
    );
  }
}
