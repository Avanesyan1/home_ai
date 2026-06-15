import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';

extension LocaleLabels on Locale {
  String get label {
    return switch (languageCode) {
      'ru' => LocaleKeys.settingsLanguageRu.tr(),
      'en' => LocaleKeys.settingsLanguageEn.tr(),
      _ => LocaleKeys.settingsLanguageEn.tr(),
    };
  }
}
