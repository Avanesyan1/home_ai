import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/theme/app_colors.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(44, 44),
      onPressed: onPressed,
      child: const Icon(
        CupertinoIcons.back,
        size: 24,
        color: AppColors.textPrimary,
      ),
    );
  }
}
