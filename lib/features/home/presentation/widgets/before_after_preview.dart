import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/theme/app_spacing.dart';
import 'package:home_ai/core/theme/app_text_styles.dart';

class BeforeAfterPreview extends StatefulWidget {
  const BeforeAfterPreview({
    super.key,
    required this.beforePath,
    required this.afterPath,
    this.interval = const Duration(seconds: 3),
    this.initialDelay = Duration.zero,
    this.showBadge = true,
  });

  final String beforePath;
  final String afterPath;
  final Duration interval;
  final Duration initialDelay;
  final bool showBadge;

  @override
  State<BeforeAfterPreview> createState() => _BeforeAfterPreviewState();
}

class _BeforeAfterPreviewState extends State<BeforeAfterPreview> {
  Timer? _timer;
  bool _showAfter = false;

  @override
  void initState() {
    super.initState();
    _startCycle();
  }

  @override
  void didUpdateWidget(BeforeAfterPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.interval != widget.interval ||
        oldWidget.initialDelay != widget.initialDelay) {
      _startCycle();
    }
  }

  void _startCycle() {
    _timer?.cancel();
    _showAfter = false;

    Future<void>.delayed(widget.initialDelay, () {
      if (!mounted) {
        return;
      }

      setState(() => _showAfter = true);

      _timer = Timer.periodic(widget.interval, (_) {
        if (!mounted) {
          return;
        }
        setState(() => _showAfter = !_showAfter);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _showAfter ? widget.afterPath : widget.beforePath;
    final label =
        _showAfter ? LocaleKeys.redesignAfter.tr() : LocaleKeys.redesignBefore.tr();

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: Image.asset(
            imagePath,
            key: ValueKey(imagePath),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            gaplessPlayback: true,
            filterQuality: FilterQuality.medium,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(
                color: AppColors.imagePlaceholder,
                child: Center(
                  child: Icon(
                    CupertinoIcons.photo,
                    color: AppColors.imagePlaceholderIcon,
                    size: 28,
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.showBadge)
          Positioned(
            top: AppSpacing.sm,
            left: AppSpacing.sm,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _PreviewBadge(
                key: ValueKey(label),
                label: label,
              ),
            ),
          ),
      ],
    );
  }
}

class _PreviewBadge extends StatelessWidget {
  const _PreviewBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.surface,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
