import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_ai/core/config/app_links.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/service/analytics/analytics_service.dart';
import 'package:home_ai/core/service/premium/premium_service.dart';
import 'package:home_ai/core/theme/app_animations.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/core/theme/screen_util_extensions.dart';
import 'package:home_ai/features/paywall/presentation/theme/paywall_colors.dart';
import 'package:home_ai/features/paywall/presentation/widgets/paywall_feature_row.dart';
import 'package:home_ai/features/paywall/presentation/widgets/paywall_hero_carousel.dart';
import 'package:home_ai/features/paywall/presentation/widgets/paywall_plan_tile.dart';
import 'package:home_ai/features/settings/presentation/utils/settings_actions.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum PaywallPlan { monthly, weekly }

class PaywallContent extends StatefulWidget {
  const PaywallContent({
    super.key,
    required this.onDismiss,
    required this.source,
    this.onPurchased,
    this.initialPlan = PaywallPlan.monthly,
    this.weeklyOnly = false,
    this.closeDelay = const Duration(seconds: 5),
    this.showRestore = true,
  });

  final VoidCallback onDismiss;
  final String source;
  final VoidCallback? onPurchased;
  final PaywallPlan initialPlan;
  final bool weeklyOnly;
  final Duration closeDelay;
  final bool showRestore;

  @override
  State<PaywallContent> createState() => _PaywallContentState();
}

class _PaywallContentState extends State<PaywallContent> {
  final _premium = PremiumService.instance;

  late PaywallPlan _selected;
  bool _isPurchasing = false;
  bool _showCloseButton = false;
  Timer? _closeTimer;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialPlan;
    unawaited(AnalyticsService.instance.logScreen('paywall'));
    unawaited(
      AnalyticsService.instance.logPaywallViewed(source: widget.source),
    );
    _premium.loadProducts();
    _premium.products.addListener(_onProductsChanged);
    _premium.havePremium.addListener(_onPremiumChanged);
    _closeTimer = Timer(widget.closeDelay, () {
      if (mounted) {
        setState(() => _showCloseButton = true);
      }
    });
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    _premium.products.removeListener(_onProductsChanged);
    _premium.havePremium.removeListener(_onPremiumChanged);
    super.dispose();
  }

  void _onProductsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onPremiumChanged() {
    if (mounted && _premium.havePremium.value) {
      _handlePurchased();
    }
  }

  void _handlePurchased() {
    if (widget.onPurchased != null) {
      widget.onPurchased!();
    } else {
      widget.onDismiss();
    }
  }

  StoreProduct? _productForPlan(PaywallPlan plan) {
    return switch (plan) {
      PaywallPlan.monthly => _premium.featuredProduct,
      PaywallPlan.weekly => _premium.weeklyProduct,
    };
  }

  String _priceForPlan(PaywallPlan plan, String fallback) {
    return _productForPlan(plan)?.priceString ?? fallback;
  }

  String _subtitleForPlan(PaywallPlan plan, String fallback) {
    if (plan == PaywallPlan.monthly) {
      final product = _premium.featuredProduct;
      if (product != null) {
        return '(${_premium.getWeeklyPrice(product)})';
      }
    }
    return fallback;
  }

  String _badgeForMonthlyPlan() {
    final monthly = _premium.featuredProduct;
    final weekly = _premium.weeklyProduct;
    if (monthly == null || weekly == null) {
      return '';
    }

    final percent = _premium.getSavingsPercent(monthly, weekly);
    if (percent == null) {
      return '';
    }

    return LocaleKeys.paywallYearlyBadge.tr(
      namedArgs: {'percent': '$percent'},
    );
  }

  Future<void> _showProductsUnavailable() {
    return showCupertinoDialog<void>(
      context: context,
      builder: (ctx) {
        return CupertinoAlertDialog(
          title: Text(LocaleKeys.paywallProductsUnavailable.tr()),
          content: Text(LocaleKeys.paywallProductsUnavailableMessage.tr()),
          actions: [
            CupertinoDialogAction(
              child: Text(
                LocaleKeys.commonOk.tr(),
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _continue() async {
    if (_premium.havePremium.value) {
      _handlePurchased();
      return;
    }

    final product = _productForPlan(_selected);
    if (product == null) {
      await _premium.loadProducts();
      if (!mounted) {
        return;
      }
      final retry = _productForPlan(_selected);
      if (retry == null) {
        await _showProductsUnavailable();
        return;
      }
    }

    final resolvedProduct = _productForPlan(_selected)!;

    setState(() => _isPurchasing = true);
    final planName = _selected.name;
    unawaited(
      AnalyticsService.instance.logPurchaseStarted(
        source: widget.source,
        plan: planName,
        productId: resolvedProduct.identifier,
      ),
    );
    final success = await _premium.buyProduct(resolvedProduct);
    if (!mounted) {
      return;
    }
    setState(() => _isPurchasing = false);

    if (success) {
      unawaited(
        AnalyticsService.instance.logPurchaseSuccess(
          source: widget.source,
          productId: resolvedProduct.identifier,
        ),
      );
      _handlePurchased();
    }
  }

  Future<void> _restore() async {
    unawaited(
      AnalyticsService.instance.logPaywallRestoreTapped(source: widget.source),
    );
    await _premium.restorePurchase(context);
    if (mounted && _premium.havePremium.value) {
      unawaited(
        AnalyticsService.instance.logRestoreSuccess(source: widget.source),
      );
      _handlePurchased();
    }
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final heroHeight = 400.h;
    final monthlyBadge = _badgeForMonthlyPlan();

    return Column(
      children: [
        SizedBox(
          height: heroHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const PaywallHeroCarousel(),
              if (_showCloseButton)
                Positioned(
                  top: topInset + 8.h,
                  left: 16.w,
                  child: _CircleIconButton(
                    icon: CupertinoIcons.xmark,
                    onPressed: () {
                      unawaited(
                        AnalyticsService.instance.logPaywallDismissed(
                          source: widget.source,
                        ),
                      );
                      widget.onDismiss();
                    },
                  ).animateFadeScale(),
                ),
            ],
          ),
        ),
        Expanded(
          child: Transform.translate(
            offset: Offset(0, -20.h),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: PaywallColors.sheetBackground,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusXl.r),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    20.w,
                    16.h,
                    20.w,
                    8.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              PaywallFeatureRow(
                                icon: CupertinoIcons.square_grid_2x2,
                                label: LocaleKeys.paywallFeature1.tr(),
                              ).animateStagger(0, stepMs: 80),
                              PaywallFeatureRow(
                                icon: CupertinoIcons.paintbrush_fill,
                                label: LocaleKeys.paywallFeature2.tr(),
                              ).animateStagger(1, stepMs: 80),
                              PaywallFeatureRow(
                                icon: CupertinoIcons.lock_fill,
                                label: LocaleKeys.paywallFeature3.tr(),
                              ).animateStagger(2, stepMs: 80),
                              PaywallFeatureRow(
                                icon: CupertinoIcons.bell_fill,
                                label: LocaleKeys.paywallFeature4.tr(),
                              ).animateStagger(3, stepMs: 80),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!widget.weeklyOnly) ...[
                            PaywallPlanTile(
                              topBadge: monthlyBadge,
                              headline: '1',
                              title: LocaleKeys.paywallYearlyTitle.tr(),
                              subtitle: _subtitleForPlan(
                                PaywallPlan.monthly,
                                LocaleKeys.paywallYearlyCaption.tr(),
                              ),
                              price: _priceForPlan(
                                PaywallPlan.monthly,
                                LocaleKeys.paywallYearlyPrice.tr(),
                              ),
                              selected: _selected == PaywallPlan.monthly,
                              highlightBadge: monthlyBadge.isNotEmpty,
                              onTap: () {
                                setState(() => _selected = PaywallPlan.monthly);
                                unawaited(
                                  AnalyticsService.instance.logPaywallPlanSelected(
                                    PaywallPlan.monthly.name,
                                  ),
                                );
                              },
                            ).animateFadeUp(
                              delay: const Duration(milliseconds: 360),
                            ),
                            SizedBox(height: 10.h),
                          ],
                          PaywallPlanTile(
                            topBadge: LocaleKeys.paywallWeeklyBadge.tr(),
                            headline: '1',
                            title: LocaleKeys.paywallWeeklyTitle.tr(),
                            subtitle: '',
                            price: _priceForPlan(
                              PaywallPlan.weekly,
                              LocaleKeys.paywallWeeklyPrice.tr(),
                            ),
                            selected: _selected == PaywallPlan.weekly,
                            onTap: () {
                              setState(() => _selected = PaywallPlan.weekly);
                              unawaited(
                                AnalyticsService.instance.logPaywallPlanSelected(
                                  PaywallPlan.weekly.name,
                                ),
                              );
                            },
                          ).animateFadeUp(
                            delay: Duration(
                              milliseconds: widget.weeklyOnly ? 360 : 440,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      CupertinoButton(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        onPressed: _isPurchasing ? null : _continue,
                        child: _isPurchasing
                            ? const CupertinoActivityIndicator(
                                color: AppColors.surface,
                              )
                            : Text(
                                LocaleKeys.paywallCta.tr(),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.surface,
                                  fontSize: 17.spClamped,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ).animateFadeUp(delay: const Duration(milliseconds: 520)),
                      SizedBox(height: 4.h),
                      _buildFooterLinks(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLinks(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.md.w,
      children: [
        _FooterLink(
          label: LocaleKeys.paywallTerms.tr(),
          onPressed: () => SettingsActions.openLink(
            context,
            AppLinks.terms,
            link: 'terms',
          ),
        ),
        _FooterLink(
          label: LocaleKeys.paywallPrivacy.tr(),
          onPressed: () => SettingsActions.openLink(
            context,
            AppLinks.privacy,
            link: 'privacy',
          ),
        ),
        _FooterLink(
          label: LocaleKeys.paywallRestore.tr(),
          onPressed: _restore,
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: SizedBox(
        width: 32.h,
        height: 32.h,
        child: Icon(icon, size: 16.h, color: CupertinoColors.black),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
          fontSize: 12.spClamped,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
