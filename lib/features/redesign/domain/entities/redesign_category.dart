import 'package:easy_localization/easy_localization.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';

enum RedesignCategory {
  interior,
  exterior,
  garden,
  floor,
}

extension RedesignCategoryX on RedesignCategory {
  String get titleKey {
    return switch (this) {
      RedesignCategory.interior => LocaleKeys.homeCardInterior,
      RedesignCategory.exterior => LocaleKeys.homeCardExterior,
      RedesignCategory.garden => LocaleKeys.homeCardGarden,
      RedesignCategory.floor => LocaleKeys.homeCardFloor,
    };
  }

  String get title => titleKey.tr();

  String get assetsFolder {
    return switch (this) {
      RedesignCategory.interior => 'interior',
      RedesignCategory.exterior => 'exterior',
      RedesignCategory.garden => 'garden',
      RedesignCategory.floor => 'floor',
    };
  }
}
