import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/core/theme/screen_util_extensions.dart';
import 'package:home_ai/features/paywall/presentation/theme/paywall_colors.dart';

class PaywallPlanTile extends StatelessWidget {
  const PaywallPlanTile({
    super.key,
    required this.topBadge,
    required this.headline,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.selected,
    required this.onTap,
    this.highlightBadge = false,
  });

  final String topBadge;
  final String headline;
  final String title;
  final String subtitle;
  final String price;
  final bool selected;
  final VoidCallback onTap;
  final bool highlightBadge;

  static const _borderWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    final radius = AppSpacing.radiusLg.r;
    final isActive = selected;

    final borderColor =
        isActive ? AppColors.primary : PaywallColors.planBorder;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: PaywallColors.sheetBackground,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor, width: _borderWidth),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            _SelectionIndicator(selected: isActive),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 16.spClamped,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (highlightBadge && topBadge.isNotEmpty) ...[
                        SizedBox(width: 8.w),
                        _Badge(label: topBadge),
                      ],
                    ],
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 12.spClamped,
                        color: PaywallColors.planMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              price,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 16.spClamped,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.w,
      height: 22.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primary : PaywallColors.sheetBackground,
        border: Border.all(
          color: selected ? AppColors.primary : PaywallColors.planBorder,
          width: 2,
        ),
      ),
      child: selected
          ? Icon(
              CupertinoIcons.checkmark,
              size: 14.w,
              color: AppColors.surface,
            )
          : null,
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.surface,
          fontSize: 10.spClamped,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
