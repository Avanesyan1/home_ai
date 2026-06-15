import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/theme/app_decorations.dart';
import 'package:home_ai/core/theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.selected = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: AppDecorations.surfaceCard(selected: selected),
      child: child,
    );

    if (onTap == null) {
      return card;
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: card,
    );
  }
}
