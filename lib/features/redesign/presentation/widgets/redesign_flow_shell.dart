import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/core/widgets/app_back_button.dart';

class RedesignFlowShell extends StatelessWidget {
  const RedesignFlowShell({
    super.key,
    required this.title,
    required this.stepIndicator,
    required this.body,
    required this.onBack,
    required this.onNext,
    required this.canGoNext,
    required this.isLastStep,
    required this.showBackButton,
  });

  final String title;
  final Widget stepIndicator;
  final Widget body;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final bool canGoNext;
  final bool isLastStep;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        middle: Text(
          title,
          style: AppTextStyles.headline,
        ),
        leading: AppBackButton(onPressed: onBack),
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            stepIndicator,
            Expanded(child: body),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.sm,
                AppSpacing.screenHorizontal,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  if (showBackButton) ...[
                    Expanded(
                      child: CupertinoButton(
                        color: AppColors.surfaceMuted,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        onPressed: onBack,
                        child: Text(
                          LocaleKeys.redesignBack.tr(),
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    flex: showBackButton ? 1 : 2,
                    child: CupertinoButton(
                      color:
                          canGoNext ? AppColors.primary : AppColors.textTertiary,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                      onPressed: canGoNext ? onNext : null,
                      child: Text(
                        isLastStep
                            ? LocaleKeys.redesignGenerate.tr()
                            : LocaleKeys.redesignNext.tr(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.surface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
