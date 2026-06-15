import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/theme/app_decorations.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.titleKey,
    required this.children,
  });

  final String titleKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.sm,
              bottom: AppSpacing.sm,
            ),
            child: Text(
              titleKey.tr().toUpperCase(),
              style: AppTextStyles.sectionHeader,
            ),
          ),
          Container(
            decoration: AppDecorations.surfaceCard(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              child: Column(children: children),
            ),
          ),
        ],
      ),
    );
  }
}
