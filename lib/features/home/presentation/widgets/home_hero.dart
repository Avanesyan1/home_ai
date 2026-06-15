import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/theme/app_animations.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.lg,
        AppSpacing.screenHorizontal,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.homeGreeting.tr(),
            style: AppTextStyles.display,
          ).animateFadeUp(),
          const SizedBox(height: AppSpacing.sm),
          Text(
            LocaleKeys.homeSubtitle.tr(),
            style: AppTextStyles.body.copyWith(fontSize: 16),
          ).animateFadeUp(delay: const Duration(milliseconds: 80)),
        ],
      ),
    );
  }
}
