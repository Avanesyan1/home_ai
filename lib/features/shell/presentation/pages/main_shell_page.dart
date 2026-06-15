import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/router/app_router.dart';
import 'package:home_ai/core/theme/app_colors.dart';

@RoutePage()
class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return AutoTabsScaffold(
      key: ValueKey(locale.languageCode),
      routes: const [
        HomeRoute(),
        GalleryRoute(),
      ],
      transitionBuilder: (_, child, _) => child,
      bottomNavigationBuilder: (_, tabsRouter) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 12,
                offset: Offset(0, -4),
              ),
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 28,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: CupertinoTabBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.textTertiary,
            backgroundColor: AppColors.surface,
            border: const Border(top: BorderSide.none),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.house),
                activeIcon: const Icon(CupertinoIcons.house_fill),
                label: LocaleKeys.homeTitle.tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.photo_on_rectangle),
                activeIcon:
                    const Icon(CupertinoIcons.photo_fill_on_rectangle_fill),
                label: LocaleKeys.galleryTitle.tr(),
              ),
            ],
          ),
        );
      },
    );
  }
}
