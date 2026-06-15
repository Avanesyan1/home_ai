import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_decorations.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/core/utils/image_picker_helper.dart';

class RedesignPhotoStep extends StatelessWidget {
  const RedesignPhotoStep({
    super.key,
    required this.imagePath,
    required this.onImageSelected,
  });

  final String? imagePath;
  final ValueChanged<String> onImageSelected;

  Future<void> _pickImage(BuildContext context) async {
    final path = await ImagePickerHelper.pickImage(context);
    if (path != null) {
      onImageSelected(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      children: [
        Text(
          LocaleKeys.redesignStepPhotoTitle.tr(),
          style: AppTextStyles.title,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          LocaleKeys.redesignStepPhotoHint.tr(),
          style: AppTextStyles.body,
        ),
        const SizedBox(height: AppSpacing.lg),
        GestureDetector(
          onTap: () => _pickImage(context),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: DecoratedBox(
              decoration: AppDecorations.surfaceCard(
                radius: AppSpacing.radiusLg,
              ),
              child: imagePath == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.camera_fill,
                          size: 40,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          LocaleKeys.redesignUploadPhoto.tr(),
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusLg - 1),
                      child: Image.file(
                        File(imagePath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
