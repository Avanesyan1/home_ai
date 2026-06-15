import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/core/widgets/icon_circle.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    this.onTap,
    this.subtitle,
    this.showDivider = true,
    this.showChevron = true,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback? onTap;
  final bool showDivider;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          IconCircle(
            icon: icon,
            color: iconColor,
            backgroundColor: iconBackground,
            size: 40,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: AppTextStyles.caption,
            ),
            if (showChevron) const SizedBox(width: AppSpacing.sm),
          ],
          if (showChevron)
            const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: AppColors.textTertiary,
            ),
        ],
      ),
    );

    return Column(
      children: [
        if (onTap != null)
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onTap,
            child: content,
          )
        else
          content,
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 72),
            child: Container(
              height: 1,
              color: AppColors.divider,
            ),
          ),
      ],
    );
  }
}
