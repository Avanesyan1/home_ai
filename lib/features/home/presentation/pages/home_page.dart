import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/config/app_assets.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/router/app_router.dart';
import 'package:home_ai/core/service/analytics/analytics_service.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/widgets/app_background.dart';
import 'package:home_ai/features/home/presentation/widgets/home_feature_card.dart';
import 'package:home_ai/features/home/presentation/widgets/home_hero.dart';
import 'package:home_ai/features/home/presentation/widgets/home_top_bar.dart';
import 'package:home_ai/features/redesign/domain/entities/redesign_category.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return CupertinoPageScaffold(
      key: ValueKey(locale.languageCode),
      backgroundColor: AppColors.background,
      child: AppBackground(
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(child: HomeTopBar()),
              SliverToBoxAdapter(child: HomeHero()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  0,
                  AppSpacing.screenHorizontal,
                  AppSpacing.xxl,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.lg,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildListDelegate([
                    _card(
                      context,
                      category: RedesignCategory.interior,
                      title: LocaleKeys.homeCardInterior.tr(),
                      staggerIndex: 0,
                      delay: Duration.zero,
                    ),
                    _card(
                      context,
                      category: RedesignCategory.exterior,
                      title: LocaleKeys.homeCardExterior.tr(),
                      staggerIndex: 1,
                      delay: const Duration(milliseconds: 750),
                    ),
                    _card(
                      context,
                      category: RedesignCategory.garden,
                      title: LocaleKeys.homeCardGarden.tr(),
                      staggerIndex: 2,
                      delay: const Duration(milliseconds: 1500),
                    ),
                    _card(
                      context,
                      category: RedesignCategory.floor,
                      title: LocaleKeys.homeCardFloor.tr(),
                      staggerIndex: 3,
                      delay: const Duration(milliseconds: 2250),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context, {
    required RedesignCategory category,
    required String title,
    required int staggerIndex,
    required Duration delay,
  }) {
    final preview = AppAssets.cardPreview(category);

    return HomeFeatureCard(
      title: title,
      beforePath: preview.before,
      afterPath: preview.after,
      initialDelay: delay,
      staggerIndex: staggerIndex,
      onTap: () {
        unawaited(
          AnalyticsService.instance.logHomeCategoryTapped(category.name),
        );
        context.router.push(RedesignFlowRoute(category: category));
      },
    );
  }
}
