import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/app.dart';
import 'package:home_ai/core/config/app_config.dart';
import 'package:home_ai/core/l10n/app_locales.dart';
import 'package:home_ai/core/database/app_database.dart';
import 'package:home_ai/firebase_options.dart';
import 'package:home_ai/presentation/services/gemini_key_service.dart';
import 'package:home_ai/core/service/premium/premium_service.dart';
import 'package:home_ai/features/gallery/data/gallery_repository.dart';
import 'package:home_ai/core/service/analytics/analytics_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Firebase init can hang on a poor network; cap it so we never block the
  // first frame. App Store reviewers run on networks where this matters.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 5));
  } catch (error) {
    debugPrint('Firebase init skipped: $error');
  }

  // Local, fast initializers that the UI depends on immediately.
  try {
    await GeminiKeyService.instance.init();
  } catch (error) {
    debugPrint('GeminiKeyService init failed: $error');
  }

  try {
    await AppDatabase.initialize();
    GalleryRepository.initialize(AppDatabase.instance);
  } catch (error) {
    debugPrint('AppDatabase init failed: $error');
  }

  EasyLocalization.logger.enableLevels = [];

  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppConfig.translationsPath,
      fallbackLocale: AppLocales.fallback,
      saveLocale: true,
      useOnlyLangCode: true,
      child: const App(),
    ),
  );

  // Network-bound (RevenueCat) — must NOT block the first frame, otherwise a
  // slow/blocked network leaves the app on a blank screen forever.
  unawaited(PremiumService.instance.init());
  unawaited(AnalyticsService.instance.init());
}