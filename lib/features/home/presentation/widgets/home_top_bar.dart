import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/router/app_router.dart';
import 'package:home_ai/core/theme/app_animations.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_decorations.dart';
import 'package:home_ai/core/theme/app_spacing.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.sm,
        AppSpacing.screenHorizontal,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.router.push(const SettingsRoute()),
            child: Container(
              width: 44,
              height: 44,
              decoration: AppDecorations.surfaceCard(radius: 14).copyWith(
                color: AppColors.surface,
              ),
              child: const Icon(
                CupertinoIcons.gear_alt_fill,
                size: 22,
                color: AppColors.textPrimary,
              ),
            ),
          ).animateFadeScale(delay: const Duration(milliseconds: 120)),
        ],
      ),
    );
  }
}
