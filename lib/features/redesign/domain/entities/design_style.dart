import 'package:easy_localization/easy_localization.dart';

class DesignStyle {
  const DesignStyle({
    required this.id,
    required this.labelKey,
    required this.imagePath,
  });

  final String id;
  final String labelKey;
  final String imagePath;

  String get label => labelKey.tr();
}
