import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:home_ai/core/logger/app_logger.dart';

/// Product analytics via Firebase Analytics.
///
/// Event naming: snake_case, max 40 chars. Params are sanitized to
/// Firebase-supported types (String / num).
class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  FirebaseAnalytics? _analytics;
  bool _initialized = false;

  bool get isEnabled => _initialized && _analytics != null;

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    if (Firebase.apps.isEmpty) {
      AppLogger.instance.warning('Analytics: Firebase not initialized');
      return;
    }

    try {
      _analytics = FirebaseAnalytics.instance;
      await _analytics!.setAnalyticsCollectionEnabled(true);
      _initialized = true;
      AppLogger.instance.info('Analytics: initialized');
    } catch (error, stackTrace) {
      AppLogger.instance.error('Analytics: init failed', error, stackTrace);
    }
  }

  // ── Screens ──────────────────────────────────────────────────────────────

  Future<void> logScreen(String screenName, {Map<String, Object?>? params}) {
    return _logEvent('screen_view', {
      'screen_name': screenName,
      ...?params,
    });
  }

  // ── App lifecycle ─────────────────────────────────────────────────────────

  Future<void> logAppOpen() => _logEvent('app_open');

  Future<void> logBootstrapRoute(String route) => _logEvent('bootstrap_route', {
        'route': route,
      });

  // ── Onboarding ────────────────────────────────────────────────────────────

  Future<void> logOnboardingStarted() => _logEvent('onboarding_started');

  Future<void> logOnboardingSlideViewed(int index) =>
      _logEvent('onboarding_slide_viewed', {'slide_index': index});

  Future<void> logOnboardingCompleted({required String method}) =>
      _logEvent('onboarding_completed', {'method': method});

  Future<void> logOnboardingSkipped() => _logEvent('onboarding_skipped');

  // ── Paywall & purchases ───────────────────────────────────────────────────

  Future<void> logPaywallViewed({required String source}) =>
      _logEvent('paywall_viewed', {'source': source});

  Future<void> logPaywallPlanSelected(String plan) =>
      _logEvent('paywall_plan_selected', {'plan': plan});

  Future<void> logPaywallDismissed({required String source}) =>
      _logEvent('paywall_dismissed', {'source': source});

  Future<void> logPaywallRestoreTapped({required String source}) =>
      _logEvent('paywall_restore_tapped', {'source': source});

  Future<void> logPurchaseStarted({
    required String source,
    required String plan,
    required String productId,
  }) =>
      _logEvent('purchase_started', {
        'source': source,
        'plan': plan,
        'product_id': productId,
      });

  Future<void> logPurchaseSuccess({
    required String source,
    required String productId,
  }) =>
      _logEvent('purchase_success', {
        'source': source,
        'product_id': productId,
      });

  Future<void> logPurchaseCancelled({required String source}) =>
      _logEvent('purchase_cancelled', {'source': source});

  Future<void> logPurchaseFailed({
    required String source,
    String? reason,
  }) =>
      _logEvent('purchase_failed', {
        'source': source,
        'reason': ?reason,
      });

  Future<void> logRestoreSuccess({required String source}) =>
      _logEvent('restore_success', {'source': source});

  Future<void> logRestoreNoPurchases({required String source}) =>
      _logEvent('restore_no_purchases', {'source': source});

  Future<void> logRestoreFailed({required String source}) =>
      _logEvent('restore_failed', {'source': source});

  Future<void> logPremiumStatusChanged(bool isPremium) =>
      _logEvent('premium_status_changed', {'is_premium': isPremium ? 1 : 0});

  // ── Redesign & generation ─────────────────────────────────────────────────

  Future<void> logRedesignFlowStarted(String category) =>
      _logEvent('redesign_flow_started', {'category': category});

  Future<void> logRedesignStepCompleted({
    required String category,
    required int step,
  }) =>
      _logEvent('redesign_step_completed', {
        'category': category,
        'step': step,
      });

  Future<void> logGenerationStarted({
    required String category,
    required String styleId,
  }) =>
      _logEvent('generation_started', {
        'category': category,
        'style_id': styleId,
      });

  Future<void> logGenerationSuccess(String category) =>
      _logEvent('generation_success', {'category': category});

  Future<void> logGenerationFailed({
    required String category,
    String? reason,
  }) =>
      _logEvent('generation_failed', {
        'category': category,
        'reason': ?reason,
      });

  Future<void> logGenerationLimitReached() =>
      _logEvent('generation_limit_reached');

  Future<void> logDesignSaved(String category) =>
      _logEvent('design_saved', {'category': category});

  // ── Gallery ───────────────────────────────────────────────────────────────

  Future<void> logGalleryItemOpened(int designId) =>
      _logEvent('gallery_item_opened', {'design_id': designId});

  Future<void> logDesignShared({required String source}) =>
      _logEvent('design_shared', {'source': source});

  Future<void> logDesignDeleted() => _logEvent('design_deleted');

  // ── Home & navigation ─────────────────────────────────────────────────────

  Future<void> logTabSelected(String tab) =>
      _logEvent('tab_selected', {'tab': tab});

  Future<void> logHomeCategoryTapped(String category) =>
      _logEvent('home_category_tapped', {'category': category});

  Future<void> logSettingsOpened() => _logEvent('settings_opened');

  Future<void> logSettingsLanguageChanged(String locale) =>
      _logEvent('settings_language_changed', {'locale': locale});

  Future<void> logSettingsLinkOpened(String link) =>
      _logEvent('settings_link_opened', {'link': link});

  // ── Force update ──────────────────────────────────────────────────────────

  Future<void> logForceUpdateViewed() => _logEvent('force_update_viewed');

  Future<void> logForceUpdateStoreTapped() =>
      _logEvent('force_update_store_tapped');

  // ── Internal ──────────────────────────────────────────────────────────────

  Future<void> _logEvent(String name, [Map<String, Object?>? params]) async {
    if (!_initialized || _analytics == null) {
      return;
    }

    try {
      final sanitized = _sanitize(params);
      await _analytics!.logEvent(name: name, parameters: sanitized);
      AppLogger.instance.info('Analytics: $name $sanitized');
    } catch (error, stackTrace) {
      AppLogger.instance.error('Analytics: log failed ($name)', error, stackTrace);
    }
  }

  Map<String, Object> _sanitize(Map<String, Object?>? params) {
    if (params == null) {
      return const {};
    }

    final result = <String, Object>{};
    for (final entry in params.entries) {
      final value = entry.value;
      if (value == null) {
        continue;
      }
      if (value is String) {
        result[entry.key] = value.length > 100 ? value.substring(0, 100) : value;
      } else if (value is num) {
        result[entry.key] = value;
      } else if (value is bool) {
        result[entry.key] = value ? 1 : 0;
      } else {
        final text = value.toString();
        result[entry.key] = text.length > 100 ? text.substring(0, 100) : text;
      }
    }
    return result;
  }
}
