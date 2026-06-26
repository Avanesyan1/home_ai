import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/router/app_router.dart';
import 'package:home_ai/core/service/analytics/analytics_service.dart';
import 'package:home_ai/core/service/generation/generation_limit_service.dart';
import 'package:home_ai/features/paywall/presentation/paywall_entry.dart';
import 'package:home_ai/features/redesign/domain/entities/redesign_category.dart';
import 'package:home_ai/features/redesign/domain/entities/redesign_draft.dart';
import 'package:home_ai/features/redesign/domain/redesign_options.dart';
import 'package:home_ai/features/redesign/presentation/widgets/redesign_flow_shell.dart';
import 'package:home_ai/features/redesign/presentation/widgets/redesign_palette_step.dart';
import 'package:home_ai/features/redesign/presentation/widgets/redesign_photo_step.dart';
import 'package:home_ai/features/redesign/presentation/widgets/redesign_step_indicator.dart';
import 'package:home_ai/features/redesign/presentation/widgets/redesign_style_step.dart';
import 'package:home_ai/features/redesign/presentation/widgets/redesign_wishes_step.dart';

@RoutePage()
class RedesignFlowPage extends StatefulWidget {
  const RedesignFlowPage({
    super.key,
    required this.category,
  });

  final RedesignCategory category;

  @override
  State<RedesignFlowPage> createState() => _RedesignFlowPageState();
}

class _RedesignFlowPageState extends State<RedesignFlowPage> {
  static const _totalSteps = 4;

  final PageController _pageController = PageController();
  final TextEditingController _wishesController = TextEditingController();

  int _currentStep = 0;
  late RedesignDraft _draft;

  @override
  void initState() {
    super.initState();
    unawaited(AnalyticsService.instance.logScreen('redesign_flow'));
    unawaited(
      AnalyticsService.instance.logRedesignFlowStarted(widget.category.name),
    );
    _draft = RedesignDraft(category: widget.category);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _wishesController.dispose();
    super.dispose();
  }

  bool get _canProceed {
    return switch (_currentStep) {
      0 => _draft.imagePath != null,
      1 => _draft.style != null,
      2 => _draft.palette != null,
      3 => true,
      _ => false,
    };
  }

  void _handleBack() {
    if (_currentStep == 0) {
      context.router.pop();
      return;
    }

    _goToStep(_currentStep - 1);
  }

  void _handleNext() {
    if (!_canProceed) {
      return;
    }

    if (_currentStep == _totalSteps - 1) {
      unawaited(_startGeneration());
      return;
    }

    _goToStep(_currentStep + 1);
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    unawaited(
      AnalyticsService.instance.logRedesignStepCompleted(
        category: widget.category.name,
        step: step,
      ),
    );
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _startGeneration() async {
    final canGenerate = await GenerationLimitService.instance.canGenerate();
    if (!mounted) {
      return;
    }

    if (!canGenerate) {
      unawaited(AnalyticsService.instance.logGenerationLimitReached());
      PaywallEntry.source = 'generation_limit';
      await context.router.push(const PaywallRoute());
      return;
    }

    final wishes = _wishesController.text.trim();

    if (!mounted) {
      return;
    }

    context.router.push(
      RedesignGeneratingRoute(
        category: widget.category,
        imagePath: _draft.imagePath!,
        styleId: _draft.style!.id,
        paletteId: _draft.palette!.id,
        wishes: wishes.isEmpty ? null : wishes,
      ),
    );
  }

  void _updateDraft(RedesignDraft draft) {
    setState(() => _draft = draft);
  }

  @override
  Widget build(BuildContext context) {
    final styles = RedesignOptions.stylesFor(widget.category);

    return RedesignFlowShell(
      title: widget.category.title,
      stepIndicator: RedesignStepIndicator(
        totalSteps: _totalSteps,
        currentStep: _currentStep,
      ),
      canGoNext: _canProceed,
      showBackButton: _currentStep > 0,
      isLastStep: _currentStep == _totalSteps - 1,
      onBack: _handleBack,
      onNext: _handleNext,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentStep = index),
        children: [
          RedesignPhotoStep(
            imagePath: _draft.imagePath,
            onImageSelected: (path) =>
                _updateDraft(_draft.copyWith(imagePath: path)),
          ),
          RedesignStyleStep(
            category: widget.category,
            styles: styles,
            selectedStyle: _draft.style,
            onStyleSelected: (style) =>
                _updateDraft(_draft.copyWith(style: style)),
          ),
          RedesignPaletteStep(
            palettes: RedesignOptions.palettes,
            selectedPalette: _draft.palette,
            onPaletteSelected: (palette) =>
                _updateDraft(_draft.copyWith(palette: palette)),
          ),
          RedesignWishesStep(controller: _wishesController),
        ],
      ),
    );
  }
}
