import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class ColorPaletteOption {
  const ColorPaletteOption({
    required this.id,
    required this.labelKey,
    required this.colors,
  });

  final String id;
  final String labelKey;
  final List<Color> colors;

  String get label => labelKey.tr();
}
