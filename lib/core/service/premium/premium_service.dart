import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/services.dart';
import 'package:home_ai/core/config/app_links.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/logger/app_logger.dart';
import 'package:home_ai/core/service/analytics/analytics_service.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumService {
  PremiumService._();

  static final PremiumService instance = PremiumService._();

  static const List<String> productIdsIos = [
    'homeai.am.week',
    'homeai.am.month',
  ];

  List<String> get productIds => productIdsIos;

  final ValueNotifier<bool> havePremium = ValueNotifier(false);
  final ValueNotifier<List<StoreProduct>> products = ValueNotifier([]);

  bool _isConfigured = false;

  bool get isConfigured => _isConfigured;
  bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  Future<void> init() async {
    if (!isSupported) {
      return;
    }

    try {
      final apiKey = AppLinks.purchasesKeyIos;
      if (apiKey.isEmpty || apiKey.contains('REPLACE_ME')) {
        AppLogger.instance.warning('RevenueCat iOS key is not configured');
        return;
      }

      await Purchases.configure(PurchasesConfiguration(apiKey));
      _isConfigured = true;
      await loadProducts();
      await checkPremiumStatus();

      Purchases.addCustomerInfoUpdateListener((_) {
        checkPremiumStatus();
      });
    } catch (error, stackTrace) {
      AppLogger.instance.error(
        'Error initializing Purchases',
        error,
        stackTrace,
      );
    }
  }

  Future<void> loadProducts({int attempt = 1}) async {
    if (!isSupported || !_isConfigured) {
      return;
    }

    products.value = await Purchases.getProducts(productIds);

    if (products.value.isEmpty && attempt < 2) {
      await loadProducts(attempt: attempt + 1);
    }

    AppLogger.instance.info('Products loaded: ${products.value.length}');
  }

  StoreProduct? productContaining(String value) {
    try {
      return products.value.firstWhere(
        (product) => product.identifier.contains(value),
      );
    } catch (_) {
      return null;
    }
  }

  StoreProduct? get weeklyProduct => productContaining('week');

  StoreProduct? get monthlyProduct => productContaining('month');

  StoreProduct? get yearlyProduct =>
      productContaining('year') ?? productContaining('annual');

  StoreProduct? get featuredProduct => yearlyProduct ?? monthlyProduct;

  Future<void> checkPremiumStatus() async {
    if (!isSupported || !_isConfigured) {
      return;
    }

    try {
      final customerInfo = await Purchases.getCustomerInfo();

      AppLogger.instance.info(
        'CustomerInfo: entitlements=${customerInfo.entitlements.all.keys.toList()}, '
        'activeSubscriptions=${customerInfo.activeSubscriptions}',
      );

      var hasActivePremium = false;

      final activeEntitlements = customerInfo.entitlements.active;
      final activeSubscriptions = customerInfo.activeSubscriptions;

      if (activeEntitlements.containsKey('Premium')) {
        hasActivePremium = true;
      }

      if (!hasActivePremium) {
        for (final id in productIds) {
          final baseId = id.contains(':') ? id.split(':').first : id;

          if (activeEntitlements.containsKey(id) ||
              activeSubscriptions.contains(id) ||
              activeSubscriptions.any(
                (sub) => sub == baseId || sub.startsWith('$baseId:'),
              )) {
            hasActivePremium = true;
            break;
          }
        }
      }

      if (havePremium.value != hasActivePremium) {
        unawaited(
          AnalyticsService.instance.logPremiumStatusChanged(hasActivePremium),
        );
      }

      havePremium.value = hasActivePremium;
      AppLogger.instance.info('Premium status: $hasActivePremium');
    } catch (error, stackTrace) {
      AppLogger.instance.error(
        'Error checking premium status',
        error,
        stackTrace,
      );
    }
  }

  Future<bool> buyProduct(StoreProduct product) async {
    if (!isSupported || !_isConfigured) {
      return false;
    }

    try {
      await Purchases.purchase(PurchaseParams.storeProduct(product));
      await checkPremiumStatus();
      return havePremium.value;
    } on PlatformException catch (error) {
      final code = PurchasesErrorHelper.getErrorCode(error);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return false;
      }
      AppLogger.instance.error('Error buying product', error);
      return false;
    } catch (error, stackTrace) {
      AppLogger.instance.error('Error buying product', error, stackTrace);
      return false;
    }
  }

  String getSubscriptionPeriod(StoreProduct product) {
    final periodISO = product.subscriptionPeriod;
    if (periodISO == null || periodISO.isEmpty) {
      return '';
    }

    if (periodISO.contains('Y')) {
      final years = _extractNumber(periodISO);
      return years == 1 ? 'year' : '$years years';
    } else if (periodISO.contains('M')) {
      final months = _extractNumber(periodISO);
      return months == 1 ? 'month' : '$months months';
    } else if (periodISO.contains('W')) {
      final weeks = _extractNumber(periodISO);
      return weeks == 1 ? 'week' : '$weeks weeks';
    } else if (periodISO.contains('D')) {
      final days = _extractNumber(periodISO);
      return days == 1 ? 'day' : '$days days';
    }

    return periodISO;
  }

  int _extractNumber(String periodISO) {
    final match = RegExp(r'(\d+)').firstMatch(periodISO);
    return match != null ? int.parse(match.group(1)!) : 1;
  }

  String getWeeklyPrice(StoreProduct product) {
    final weeklyPrice = _weeklyPriceValue(product);
    if (weeklyPrice == null) {
      return product.priceString;
    }

    final currencySymbol =
        product.currencyCode == 'USD' ? '\$' : product.currencyCode;
    return '$currencySymbol${weeklyPrice.toStringAsFixed(2)}/week';
  }

  /// Savings of [monthly] vs paying [weekly] every week (1–99), or null.
  int? getSavingsPercent(StoreProduct monthly, StoreProduct weekly) {
    final weeklyEquivalent = _weeklyPriceValue(monthly);
    final weeklyPrice = _weeklyPriceValue(weekly);
    if (weeklyEquivalent == null ||
        weeklyPrice == null ||
        weeklyPrice <= 0 ||
        weeklyEquivalent >= weeklyPrice) {
      return null;
    }

    final savings = ((weeklyPrice - weeklyEquivalent) / weeklyPrice) * 100;
    return savings.round().clamp(1, 99);
  }

  double? _weeklyPriceValue(StoreProduct product) {
    final price = product.price;
    final periodISO = product.subscriptionPeriod;

    if (periodISO == null || periodISO.isEmpty) {
      return null;
    }

    if (periodISO.contains('Y')) {
      final years = _extractNumber(periodISO);
      return (price / years) / 52.143;
    } else if (periodISO.contains('M')) {
      final months = _extractNumber(periodISO);
      return (price / months) / 4.345;
    } else if (periodISO.contains('W')) {
      final weeks = _extractNumber(periodISO);
      return price / weeks;
    } else if (periodISO.contains('D')) {
      final days = _extractNumber(periodISO);
      return (price / days) * 7;
    }

    return null;
  }

  bool hasTrialPeriod(StoreProduct product) {
    final introductoryPrice = product.introductoryPrice;
    if (introductoryPrice == null) {
      return false;
    }

    return introductoryPrice.period.isNotEmpty;
  }

  String? getTrialPeriodInfo(StoreProduct product) {
    final introductoryPrice = product.introductoryPrice;
    if (introductoryPrice == null) {
      return null;
    }

    final periodISO = introductoryPrice.period;
    if (periodISO.isEmpty) {
      return null;
    }

    final numberOfUnits = _extractNumber(periodISO);
    String unit = '';

    if (periodISO.contains('Y')) {
      unit = numberOfUnits == 1 ? 'year' : 'years';
    } else if (periodISO.contains('M')) {
      unit = numberOfUnits == 1 ? 'month' : 'months';
    } else if (periodISO.contains('W')) {
      unit = numberOfUnits == 1 ? 'week' : 'weeks';
    } else if (periodISO.contains('D')) {
      unit = numberOfUnits == 1 ? 'day' : 'days';
    }

    return '${numberOfUnits == 1 ? '' : '$numberOfUnits '}$unit free trial';
  }

  Map<String, dynamic> getProductInfo(StoreProduct product) {
    return {
      'id': product.identifier,
      'title': product.title,
      'description': product.description,
      'price': product.priceString,
      'weeklyPrice': getWeeklyPrice(product),
      'subscriptionPeriod': getSubscriptionPeriod(product),
      'hasTrial': hasTrialPeriod(product),
      'trialInfo': getTrialPeriodInfo(product),
    };
  }

  Future<void> restorePurchase(BuildContext context) async {
    if (!isSupported || !_isConfigured) {
      return;
    }

    try {
      await Purchases.restorePurchases();
      await checkPremiumStatus();

      if (!context.mounted) {
        return;
      }

      if (havePremium.value) {
        await showCupertinoDialog<void>(
          context: context,
          builder: (ctx) {
            return CupertinoAlertDialog(
              title: Text(LocaleKeys.paywallPurchasesRestored.tr()),
              content: Text(LocaleKeys.paywallPurchasesRestoredMessage.tr()),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    LocaleKeys.commonOk.tr(),
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  onPressed: () => ctx.pop(),
                ),
              ],
            );
          },
        );
        return;
      }

      await showCupertinoDialog<void>(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
            title: Text(LocaleKeys.paywallNoPurchasesFound.tr()),
            content: Text(LocaleKeys.paywallNoPurchasesFoundMessage.tr()),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  LocaleKeys.commonOk.tr(),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                onPressed: () => ctx.pop(),
              ),
            ],
          );
        },
      );
    } catch (error, stackTrace) {
      AppLogger.instance.error('Error restoring purchases', error, stackTrace);

      if (!context.mounted) {
        return;
      }

      await showCupertinoDialog<void>(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
            title: Text(LocaleKeys.paywallErrorRestoring.tr()),
            content: Text(LocaleKeys.paywallErrorRestoringMessage.tr()),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  LocaleKeys.commonOk.tr(),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                onPressed: () => ctx.pop(),
              ),
            ],
          );
        },
      );
    }
  }
}
