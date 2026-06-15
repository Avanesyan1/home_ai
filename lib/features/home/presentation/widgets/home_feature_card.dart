import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/theme/app_animations.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_decorations.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/features/home/presentation/widgets/before_after_preview.dart';

class HomeFeatureCard extends StatelessWidget {
  const HomeFeatureCard({
    super.key,
    required this.title,
    required this.beforePath,
    required this.afterPath,
    this.onTap,
    this.initialDelay = Duration.zero,
    this.staggerIndex = 0,
  });

  final String title;
  final String beforePath;
  final String afterPath;
  final VoidCallback? onTap;
  final Duration initialDelay;
  final int staggerIndex;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onTap,
      child: SizedBox.expand(
        child: DecoratedBox(
          decoration: AppDecorations.imageCard(radius: AppSpacing.radiusLg),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: Stack(
              fit: StackFit.expand,
              children: [
                BeforeAfterPreview(
                  beforePath: beforePath,
                  afterPath: afterPath,
                  initialDelay: initialDelay,
                  showBadge: false,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x00000000),
                        Color(0x55000000),
                        Color(0xCC000000),
                      ],
                      stops: [0.5, 0.78, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  bottom: AppSpacing.md,
                  child: Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animateStagger(staggerIndex, stepMs: 90);
  }
}
