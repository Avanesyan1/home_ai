import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/features/gallery/presentation/pages/gallery_detail_page.dart';
import 'package:home_ai/features/gallery/presentation/pages/gallery_page.dart';
import 'package:home_ai/features/home/presentation/pages/home_page.dart';
import 'package:home_ai/features/onboarding/presentation/pages/app_bootstrap_page.dart';
import 'package:home_ai/features/onboarding/presentation/pages/force_update_page.dart';
import 'package:home_ai/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:home_ai/features/paywall/presentation/pages/paywall_page.dart';
import 'package:home_ai/features/redesign/domain/entities/redesign_category.dart';
import 'package:home_ai/features/redesign/presentation/pages/redesign_flow_page.dart';
import 'package:home_ai/features/redesign/presentation/pages/redesign_generating_page.dart';
import 'package:home_ai/features/redesign/presentation/pages/redesign_result_page.dart';
import 'package:home_ai/features/settings/presentation/pages/settings_page.dart';
import 'package:home_ai/features/shell/presentation/pages/main_shell_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: AppBootstrapRoute.page, initial: true),
        AutoRoute(page: ForceUpdateRoute.page),
        AutoRoute(page: OnboardingRoute.page),
        AutoRoute(page: PaywallRoute.page),
        AutoRoute(
          page: MainShellRoute.page,
          children: [
            AutoRoute(page: HomeRoute.page, initial: true),
            AutoRoute(page: GalleryRoute.page),
          ],
        ),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: RedesignFlowRoute.page),
        AutoRoute(page: RedesignGeneratingRoute.page),
        AutoRoute(page: RedesignResultRoute.page),
        AutoRoute(page: GalleryDetailRoute.page),
      ];
}
