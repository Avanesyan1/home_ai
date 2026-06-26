import 'dart:async';

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/helpers/gallery_helper.dart';
import 'package:home_ai/core/helpers/share_helper.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/service/analytics/analytics_service.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_decorations.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';
import 'package:home_ai/core/widgets/app_back_button.dart';
import 'package:home_ai/features/gallery/data/gallery_repository.dart';
import 'package:home_ai/features/gallery/domain/entities/saved_design.dart';
import 'package:home_ai/features/redesign/presentation/widgets/hold_to_compare_view.dart';

@RoutePage()
class GalleryDetailPage extends StatefulWidget {
  const GalleryDetailPage({
    super.key,
    required this.designId,
  });

  final int designId;

  @override
  State<GalleryDetailPage> createState() => _GalleryDetailPageState();
}

class _GalleryDetailPageState extends State<GalleryDetailPage> {
  SavedDesign? _design;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    unawaited(AnalyticsService.instance.logScreen('gallery_detail'));
    _loadDesign();
  }

  Future<void> _loadDesign() async {
    final design = await GalleryRepository.instance.getById(widget.designId);
    if (!mounted) {
      return;
    }

    setState(() {
      _design = design;
      _isLoading = false;
    });
  }

  Future<void> _shareImage(BuildContext anchorContext) async {
    final design = _design;
    if (design == null || _isSharing) {
      return;
    }

    setState(() => _isSharing = true);

    try {
      await ShareHelper.shareImage(
        filePath: design.afterPath,
        anchorContext: anchorContext,
      );
      unawaited(
        AnalyticsService.instance.logDesignShared(source: 'gallery_detail'),
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
    final design = _design;
    if (design == null || _isSaving) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final bytes = await File(design.afterPath).readAsBytes();
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

  Future<void> _confirmDelete() async {
    final shouldDelete = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(LocaleKeys.galleryDeleteTitle.tr()),
        content: Text(LocaleKeys.galleryDeleteMessage.tr()),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(LocaleKeys.commonCancel.tr()),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(LocaleKeys.galleryDeleteConfirm.tr()),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    await GalleryRepository.instance.delete(widget.designId);
    unawaited(AnalyticsService.instance.logDesignDeleted());
    if (mounted) {
      context.router.pop();
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
          LocaleKeys.galleryDetailTitle.tr(),
          style: AppTextStyles.headline,
        ),
        leading: AppBackButton(
          onPressed: () => context.router.pop(),
        ),
        automaticallyImplyLeading: false,
        trailing: _design == null
            ? null
            : CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _confirmDelete,
                child: const Icon(
                  CupertinoIcons.delete,
                  color: AppColors.textSecondary,
                ),
              ),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : _design == null
                ? Center(
                    child: Text(
                      LocaleKeys.galleryNotFound.tr(),
                      style: AppTextStyles.body,
                    ),
                  )
                : _buildContent(_design!),
      ),
    );
  }

  Widget _buildContent(SavedDesign design) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: HoldToCompareView(
              beforePath: design.beforePath,
              afterPath: design.afterPath,
            ),
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
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _ActionButton(
                  icon: CupertinoIcons.arrow_down_to_line,
                  label: LocaleKeys.redesignSave.tr(),
                  isLoading: _isSaving,
                  onPressed: (_) => _saveImage(),
                ),
              ),
            ],
          ),
        ],
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
