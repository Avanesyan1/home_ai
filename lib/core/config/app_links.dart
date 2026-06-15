abstract final class AppLinks {
  static const String appStoreId = '6780173735';

  static const String supportEmail = 'avanesyan.apps@gmail.com';

  static const String privacyPolicy = 'https://docs.google.com/document/d/1DSMIQB0o30SsmAXOZE6QP9kftqgKIWGW7N_icpedgzw/edit?usp=sharing';
  static const String termsOfService = 'https://docs.google.com/document/d/1a-MjDaw_DEJxSfGhQwV953mtRqpi4ZHAIzCt1YVgUcs/edit?usp=sharing';

  static Uri get appStore => Uri.parse(
        'https://apps.apple.com/app/id$appStoreId',
      );

  static Uri get appStoreReview => Uri.parse(
        'https://apps.apple.com/app/id$appStoreId?action=write-review',
      );

  static Uri get support => Uri(
        scheme: 'mailto',
        path: supportEmail,
      );

  static Uri get privacy => Uri.parse(privacyPolicy);
  static Uri get terms => Uri.parse(termsOfService);

  static const String purchasesKeyIos = 'appl_ZFluajsCeXAsORVquZahdlQjWHh';
}
