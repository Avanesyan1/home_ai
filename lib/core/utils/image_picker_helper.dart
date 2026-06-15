import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:image_picker/image_picker.dart';

abstract final class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImage(BuildContext context) async {
    final source = await showCupertinoModalPopup<ImageSource>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () =>
                Navigator.of(sheetContext).pop(ImageSource.gallery),
            child: Text(LocaleKeys.redesignGallery.tr()),
          ),
          CupertinoActionSheetAction(
            onPressed: () =>
                Navigator.of(sheetContext).pop(ImageSource.camera),
            child: Text(LocaleKeys.redesignCamera.tr()),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(sheetContext).pop(),
          child: Text(LocaleKeys.commonCancel.tr()),
        ),
      ),
    );

    if (source == null) {
      return null;
    }

    final image = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    return image?.path;
  }
}
