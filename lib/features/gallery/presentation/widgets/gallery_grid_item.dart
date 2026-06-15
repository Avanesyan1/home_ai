import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_decorations.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/features/gallery/domain/entities/saved_design.dart';

class GalleryGridItem extends StatelessWidget {
  const GalleryGridItem({
    super.key,
    required this.design,
    required this.onTap,
  });

  final SavedDesign design;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: DecoratedBox(
        decoration: AppDecorations.imageCard(radius: AppSpacing.radiusLg),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Image.file(
            File(design.afterPath),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(
                color: AppColors.imagePlaceholder,
                child: Center(
                  child: Icon(
                    CupertinoIcons.photo,
                    color: AppColors.imagePlaceholderIcon,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
