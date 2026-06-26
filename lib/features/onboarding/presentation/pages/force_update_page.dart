import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/config/app_links.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/service/analytics/analytics_service.dart';
import 'package:home_ai/core/theme/app_animations.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/core/utils/link_launcher.dart';
import 'package:home_ai/core/widgets/app_background.dart';

@RoutePage()
class ForceUpdatePage extends StatefulWidget {
  const ForceUpdatePage({super.key});

  @override
  State<ForceUpdatePage> createState() => _ForceUpdatePageState();
}

class _ForceUpdatePageState extends State<ForceUpdatePage> {
  @override
  void initState() {
    super.initState();
    unawaited(AnalyticsService.instance.logScreen('force_update'));
    unawaited(AnalyticsService.instance.logForceUpdateViewed());
  }

  Future<void> _openStore() async {
    unawaited(AnalyticsService.instance.logForceUpdateStoreTapped());
    await LinkLauncher.open(AppLinks.appStore);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: CupertinoPageScaffold(
        backgroundColor: AppColors.background,
        child: AppBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          CupertinoIcons.arrow_up_circle_fill,
                          size: 72,
                          color: AppColors.primary,
                        ).animateFadeScale(),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          LocaleKeys.forceUpdateTitle.tr(),
                          style: AppTextStyles.title,
                          textAlign: TextAlign.center,
                        ).animateFadeUp(delay: const Duration(milliseconds: 100)),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          LocaleKeys.forceUpdateMessage.tr(),
                          style: AppTextStyles.body,
                          textAlign: TextAlign.center,
                        ).animateFadeUp(delay: const Duration(milliseconds: 180)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: CupertinoButton(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      onPressed: _openStore,
                      child: Text(
                        LocaleKeys.forceUpdateButton.tr(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.surface,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ).animateFadeUp(delay: const Duration(milliseconds: 280)),
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
