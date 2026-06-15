import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/widgets/app_back_button.dart';

class SettingsNavBar extends StatelessWidget {
  const SettingsNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.screenHorizontal,
        0,
      ),
      child: Row(
        children: [
          AppBackButton(onPressed: () => context.router.pop()),
        ],
      ),
    );
  }
}
