import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/router/app_router.dart';
import 'package:home_ai/core/service/ai/ai_service.dart';
import 'package:home_ai/core/service/generation/generation_limit_service.dart';
import 'package:home_ai/core/theme/app_animations.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/core/helpers/gallery_helper.dart';
import 'package:home_ai/features/gallery/data/gallery_repository.dart';
import 'package:home_ai/features/redesign/domain/entities/redesign_category.dart';
import 'package:home_ai/features/redesign/domain/entities/redesign_draft.dart';
import 'package:home_ai/features/redesign/domain/redesign_options.dart';
import 'package:home_ai/core/widgets/app_back_button.dart';
import 'package:home_ai/features/redesign/domain/redesign_prompt_builder.dart';

@RoutePage()
class RedesignGeneratingPage extends StatefulWidget {
  const RedesignGeneratingPage({
    super.key,
    required this.category,
    required this.imagePath,
    required this.styleId,
    required this.paletteId,
    this.wishes,
  });

  final RedesignCategory category;
  final String imagePath;
  final String styleId;
  final String paletteId;
  final String? wishes;

  @override
  State<RedesignGeneratingPage> createState() => _RedesignGeneratingPageState();
}

class _RedesignGeneratingPageState extends State<RedesignGeneratingPage> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  Future<void> _generate() async {
    setState(() => _errorMessage = null);

    try {
      final styles = RedesignOptions.stylesFor(widget.category);
      final style = styles.firstWhere((item) => item.id == widget.styleId);
      final palette = RedesignOptions.palettes.firstWhere(
        (item) => item.id == widget.paletteId,
      );

      final draft = RedesignDraft(
        category: widget.category,
        imagePath: widget.imagePath,
        style: style,
        palette: palette,
        wishes: widget.wishes ?? '',
      );

      final imageBytes = await File(widget.imagePath).readAsBytes();
      final prompt = RedesignPromptBuilder.build(draft);
      final result = await AiService.instance.generateImage(
        prompt: prompt,
        imageBytes: imageBytes,
      );

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final afterPath = await GalleryHelper.persistImageBytes(
        result,
        filename: 'after_$timestamp.jpg',
      );

      if (!mounted) {
        return;
      }

      if (afterPath == null) {
        setState(() => _errorMessage = LocaleKeys.redesignError.tr());
        return;
      }

      final beforePath = await GalleryHelper.persistImageFile(
        widget.imagePath,
        filename: 'before_$timestamp.jpg',
      );

      if (beforePath == null) {
        setState(() => _errorMessage = LocaleKeys.redesignError.tr());
        return;
      }

      await GalleryRepository.instance.save(
        category: widget.category,
        beforePath: beforePath,
        afterPath: afterPath,
        styleId: widget.styleId,
        paletteId: widget.paletteId,
        wishes: widget.wishes ?? '',
      );

      await GenerationLimitService.instance.consumeFreeGeneration();

      if (!mounted) {
        return;
      }

      await context.router.replace(
        RedesignResultRoute(
          category: widget.category,
          beforePath: beforePath,
          afterPath: afterPath,
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() => _errorMessage = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        automaticallyImplyLeading: false,
        leading: AppBackButton(onPressed: () => context.router.pop()),
        middle: Text(
          LocaleKeys.redesignGeneratingTitle.tr(),
          style: AppTextStyles.headline,
        ),
      ),
      child: SafeArea(
        child: _errorMessage == null ? _buildLoading() : _buildError(),
      ),
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        children: [
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ).animateFadeScale().animateShimmer(),
          const SizedBox(height: AppSpacing.xl),
          const CupertinoActivityIndicator(radius: 18).animatePulse(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            LocaleKeys.redesignGeneratingTitle.tr(),
            style: AppTextStyles.title,
            textAlign: TextAlign.center,
          ).animateFadeUp(delay: const Duration(milliseconds: 120)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            LocaleKeys.redesignGeneratingSubtitle.tr(),
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ).animateFadeUp(delay: const Duration(milliseconds: 200)),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_triangle,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            LocaleKeys.redesignError.tr(),
            style: AppTextStyles.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _errorMessage!,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  onPressed: () => context.router.pop(),
                  child: Text(LocaleKeys.redesignBack.tr()),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: CupertinoButton(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  onPressed: _generate,
                  child: Text(
                    LocaleKeys.redesignTryAgain.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.surface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
