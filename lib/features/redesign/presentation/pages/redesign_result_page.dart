import 'dart:async';

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/helpers/gallery_helper.dart';
import 'package:home_ai/core/helpers/share_helper.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/service/analytics/analytics_service.dart';
import 'package:home_ai/core/theme/app_animations.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_decorations.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/features/redesign/domain/entities/redesign_category.dart';
import 'package:home_ai/core/widgets/app_back_button.dart';
import 'package:home_ai/features/redesign/presentation/widgets/hold_to_compare_view.dart';

@RoutePage()
class RedesignResultPage extends StatefulWidget {
  const RedesignResultPage({
    super.key,
    required this.category,
    required this.beforePath,
    required this.afterPath,
  });

  final RedesignCategory category;
  final String beforePath;
  final String afterPath;

  @override
  State<RedesignResultPage> createState() => _RedesignResultPageState();
}

class _RedesignResultPageState extends State<RedesignResultPage> {
  bool _isSaving = false;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    unawaited(AnalyticsService.instance.logScreen('redesign_result'));
  }

  Future<void> _shareImage(BuildContext anchorContext) async {
    if (_isSharing) {
      return;
    }

    setState(() => _isSharing = true);

    try {
      await ShareHelper.shareImage(
        filePath: widget.afterPath,
        anchorContext: anchorContext,
      );
      unawaited(
        AnalyticsService.instance.logDesignShared(source: 'result'),
      );
    } catch (_) {
      if (mounted) {
        _showMessage(
          title: LocaleKeys.commonError.tr(),
          message: LocaleKeys.redesignShareError.tr(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  Future<void> _saveImage() async {
    if (_isSaving) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final bytes = await File(widget.afterPath).readAsBytes();
      final success = await GalleryHelper.saveImageToGallery(bytes);

      if (!mounted) {
        return;
      }

      _showMessage(
        title: success
            ? LocaleKeys.redesignSavedTitle.tr()
            : LocaleKeys.commonError.tr(),
        message: success
            ? LocaleKeys.redesignSavedSuccess.tr()
            : LocaleKeys.redesignSaveError.tr(),
      );
    } catch (_) {
      if (mounted) {
        _showMessage(
          title: LocaleKeys.commonError.tr(),
          message: LocaleKeys.redesignSaveError.tr(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showMessage({required String title, required String message}) {
    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(LocaleKeys.commonOk.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        middle: Text(
          LocaleKeys.redesignResultTitle.tr(),
          style: AppTextStyles.headline,
        ),
        leading: AppBackButton(
          onPressed: () => context.router.popUntilRoot(),
        ),
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: HoldToCompareView(
                  beforePath: widget.beforePath,
                  afterPath: widget.afterPath,
                ).animateFadeScale(),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: CupertinoIcons.share,
                      label: LocaleKeys.redesignShare.tr(),
                      isLoading: _isSharing,
                      onPressed: _shareImage,
                    ),
                  ).animateStagger(0, stepMs: 80),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _ActionButton(
                      icon: CupertinoIcons.arrow_down_to_line,
                      label: LocaleKeys.redesignSave.tr(),
                      isLoading: _isSaving,
                      onPressed: (_) => _saveImage(),
                    ),
                  ).animateStagger(1, stepMs: 80),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              CupertinoButton(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                onPressed: () => context.router.popUntilRoot(),
                child: Text(
                  LocaleKeys.redesignDone.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.surface,
                  ),
                ),
              ).animateFadeUp(delay: const Duration(milliseconds: 220)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final void Function(BuildContext context) onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: isLoading ? null : () => onPressed(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: AppDecorations.surfaceCard(radius: AppSpacing.radiusMd),
        child: isLoading
            ? const CupertinoActivityIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: AppColors.textPrimary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(label, style: AppTextStyles.bodyMedium),
                ],
              ),
      ),
    );
  }
}
