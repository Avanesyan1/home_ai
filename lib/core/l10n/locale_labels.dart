import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';

extension LocaleLabels on Locale {
  String get label {
    return switch (languageCode) {
      'en' => LocaleKeys.settingsLanguageEn.tr(),
      'ru' => LocaleKeys.settingsLanguageRu.tr(),
      'es' => LocaleKeys.settingsLanguageEs.tr(),
      'de' => LocaleKeys.settingsLanguageDe.tr(),
      'fr' => LocaleKeys.settingsLanguageFr.tr(),
      'pt' => LocaleKeys.settingsLanguagePt.tr(),
      'it' => LocaleKeys.settingsLanguageIt.tr(),
      'tr' => LocaleKeys.settingsLanguageTr.tr(),
      'ja' => LocaleKeys.settingsLanguageJa.tr(),
      'ko' => LocaleKeys.settingsLanguageKo.tr(),
      'zh' => LocaleKeys.settingsLanguageZh.tr(),
      _ => LocaleKeys.settingsLanguageEn.tr(),
    };
  }
}
