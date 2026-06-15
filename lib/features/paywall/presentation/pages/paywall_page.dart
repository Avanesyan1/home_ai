import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/router/app_router.dart';
import 'package:home_ai/features/paywall/presentation/theme/paywall_colors.dart';
import 'package:home_ai/features/paywall/presentation/widgets/paywall_content.dart';

@RoutePage()
class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  Future<void> _goMain(BuildContext context) async {
    if (!context.mounted) {
      return;
    }
    if (context.router.canPop()) {
      await context.router.maybePop();
      return;
    }
    await context.router.replace(const MainShellRoute());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: PaywallColors.sheetBackground,
      child: PaywallContent(
        onDismiss: () => _goMain(context),
        onPurchased: () => _goMain(context),
      ),
    );
  }
}
