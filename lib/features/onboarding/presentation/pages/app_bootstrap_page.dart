import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/router/app_router.dart';
import 'package:home_ai/core/service/update/app_update_service.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/core/widgets/app_background.dart';
import 'package:home_ai/features/onboarding/data/onboarding_storage.dart';

@RoutePage()
class AppBootstrapPage extends StatefulWidget {
  const AppBootstrapPage({super.key});

  @override
  State<AppBootstrapPage> createState() => _AppBootstrapPageState();
}

class _AppBootstrapPageState extends State<AppBootstrapPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirect());
  }

  Future<void> _redirect() async {
    try {
      await AppUpdateService.instance.check().timeout(
            const Duration(seconds: 6),
          );
    } catch (_) {
      // Never block startup on a slow/failed remote check (fail-open).
    }
    if (!mounted) {
      return;
    }

    if (AppUpdateService.instance.isUpdateRequired) {
      await context.router.replace(const ForceUpdateRoute());
      return;
    }

    final completed = await OnboardingStorage.isCompleted();
    if (!mounted) {
      return;
    }

    if (completed) {
      await context.router.replace(const MainShellRoute());
    } else {
      await context.router.replace(const OnboardingRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: AppBackground(
        child: Center(
          child: CupertinoActivityIndicator(radius: 16),
        ),
      ),
    );
  }
}
