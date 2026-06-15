import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/config/app_links.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/router/app_router.dart';
import 'package:home_ai/core/service/premium/premium_service.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/core/widgets/app_background.dart';
import 'package:home_ai/features/onboarding/data/onboarding_storage.dart';
import 'package:home_ai/features/onboarding/presentation/widgets/onboarding_page_indicator.dart';
import 'package:home_ai/features/onboarding/presentation/widgets/onboarding_slide_content.dart';
import 'package:home_ai/features/settings/presentation/utils/settings_actions.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _totalPages = 4;
  static const _paywallPageIndex = 3;

  final _pageController = PageController();
  final _premium = PremiumService.instance;

  var _currentPage = 0;
  var _isPurchasing = false;
  var _showCloseButton = false;
  Timer? _closeTimer;

  static const _slideImages = [
    'assets/styles/interior/scandinavian.jpeg',
    'assets/styles/interior/modern.jpeg',
    'assets/styles/garden/zen.jpeg',
    'assets/styles/interior/luxury.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _premium.loadProducts();
    _premium.havePremium.addListener(_onPremiumChanged);
    _premium.products.addListener(_onProductsChanged);
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    _premium.havePremium.removeListener(_onPremiumChanged);
    _premium.products.removeListener(_onProductsChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onProductsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onPremiumChanged() {
    if (mounted && _premium.havePremium.value) {
      unawaited(_finishOnboarding());
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);

    if (index == _paywallPageIndex) {
      _premium.loadProducts();
      _startCloseTimer();
    } else {
      _closeTimer?.cancel();
      _showCloseButton = false;
    }
  }

  void _startCloseTimer() {
    _closeTimer?.cancel();
    _closeTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _currentPage == _paywallPageIndex) {
        setState(() => _showCloseButton = true);
      }
    });
  }

  Future<void> _finishOnboarding() async {
    await OnboardingStorage.markCompleted();
    if (!mounted) {
      return;
    }
    await context.router.replace(const MainShellRoute());
  }

  void _nextPage() {
    if (_currentPage >= _totalPages - 1) {
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  String _titleForPage(int index) {
    return switch (index) {
      0 => LocaleKeys.onboardingSlide1Title.tr(),
      1 => LocaleKeys.onboardingSlide2Title.tr(),
      2 => LocaleKeys.onboardingSlide3Title.tr(),
      _ => LocaleKeys.onboardingSlide4Title.tr(),
    };
  }

  String _subtitleForPage(int index) {
    if (index == _paywallPageIndex) {
      final price = _premium.weeklyProduct?.priceString ??
          LocaleKeys.paywallWeeklyPrice.tr();
      return LocaleKeys.onboardingSlide4Subtitle.tr(
        namedArgs: {'price': price},
      );
    }

    return switch (index) {
      0 => LocaleKeys.onboardingSlide1Subtitle.tr(),
      1 => LocaleKeys.onboardingSlide2Subtitle.tr(),
      2 => LocaleKeys.onboardingSlide3Subtitle.tr(),
      _ => LocaleKeys.onboardingSlide4Subtitle.tr(
          namedArgs: {'price': LocaleKeys.paywallWeeklyPrice.tr()},
        ),
    };
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

  Future<void> _purchaseWeekly() async {
    if (_premium.havePremium.value) {
      await _finishOnboarding();
      return;
    }

    var product = _premium.weeklyProduct;
    if (product == null) {
      await _premium.loadProducts();
      if (!mounted) {
        return;
      }
      product = _premium.weeklyProduct;
      if (product == null) {
        await _showProductsUnavailable();
        return;
      }
    }

    setState(() => _isPurchasing = true);
    final success = await _premium.buyProduct(product);
    if (!mounted) {
      return;
    }
    setState(() => _isPurchasing = false);

    if (success) {
      await _finishOnboarding();
    }
  }

  Future<void> _restore() async {
    await _premium.restorePurchase(context);
    if (mounted && _premium.havePremium.value) {
      await _finishOnboarding();
    }
  }

  Future<void> _onPrimaryPressed() async {
    if (_currentPage < _paywallPageIndex) {
      _nextPage();
      return;
    }
    await _purchaseWeekly();
  }

  @override
  Widget build(BuildContext context) {
    final isPaywallPage = _currentPage == _paywallPageIndex;
    final buttonLabel = isPaywallPage
        ? LocaleKeys.paywallCta.tr()
        : LocaleKeys.onboardingNext.tr();

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: AppBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _totalPages,
                      onPageChanged: _onPageChanged,
                      itemBuilder: (context, index) {
                        return OnboardingSlideContent(
                          imagePath: _slideImages[index],
                          title: _titleForPage(index),
                          subtitle: _subtitleForPage(index),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenHorizontal,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OnboardingPageIndicator(
                          count: _totalPages,
                          currentIndex: _currentPage,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        CupertinoButton(
                          color: AppColors.primary,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          onPressed:
                              _isPurchasing ? null : _onPrimaryPressed,
                          child: _isPurchasing
                              ? const CupertinoActivityIndicator(
                                  color: AppColors.surface,
                                )
                              : Text(
                                  buttonLabel,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.surface,
                                  ),
                                ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _buildFooterLinks(context),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ],
              ),
              if (_showCloseButton)
                Positioned(
                  top: 0,
                  right: AppSpacing.screenHorizontal - 4,
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    minimumSize: Size.zero,
                    onPressed: _finishOnboarding,
                    child: Icon(
                      CupertinoIcons.xmark,
                      size: 14,
                      color: AppColors.textTertiary.withValues(alpha: 0.45),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLinks(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        _FooterLink(
          label: LocaleKeys.paywallTerms.tr(),
          onPressed: () => SettingsActions.openLink(context, AppLinks.terms),
        ),
        _FooterLink(
          label: LocaleKeys.paywallPrivacy.tr(),
          onPressed: () =>
              SettingsActions.openLink(context, AppLinks.privacy),
        ),
        _FooterLink(
          label: LocaleKeys.paywallRestore.tr(),
          onPressed: _restore,
        ),
      ],
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
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
