import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/config/app_assets.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/router/app_router.dart';
import 'package:home_ai/core/service/analytics/analytics_service.dart';
import 'package:home_ai/core/theme/app_animations.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_decorations.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/features/paywall/presentation/paywall_entry.dart';

class SettingsProBanner extends StatelessWidget {
  const SettingsProBanner({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          unawaited(AnalyticsService.instance.logSettingsLinkOpened('pro_banner'));
          PaywallEntry.source = 'settings';
          context.router.push(const PaywallRoute());
        },
        child: DecoratedBox(
          decoration: AppDecorations.imageCard(radius: AppSpacing.radiusLg),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: SizedBox(
              height: 148,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Image.asset(
                          AppAssets.cardInteriorBefore,
                          fit: BoxFit.cover,
                          errorBuilder: _imageError,
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          AppAssets.cardInteriorAfter,
                          fit: BoxFit.cover,
                          errorBuilder: _imageError,
                        ),
                      ),
                    ],
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xE6000000),
                          Color(0x99000000),
                          Color(0xCC000000),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusSm,
                                  ),
                                ),
                                child: Text(
                                  LocaleKeys.settingsBannerBadge.tr(),
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.1,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                LocaleKeys.settingsBannerTitle.tr(),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.surface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                LocaleKeys.settingsBannerSubtitle.tr(),
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.surface.withValues(
                                    alpha: 0.82,
                                  ),
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.arrow_right,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animateFadeScale();
  }

  Widget _imageError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return const ColoredBox(color: AppColors.imagePlaceholder);
  }
}
