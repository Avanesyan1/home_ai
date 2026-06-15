import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/theme/app_colors.dart';
import 'package:home_ai/features/settings/presentation/widgets/settings_tile.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsVersionTile extends StatelessWidget {
  const SettingsVersionTile({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;

    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.data?.version;

        return SettingsTile(
          title: LocaleKeys.settingsVersion.tr(),
          subtitle: version ?? '—',
          icon: CupertinoIcons.info_circle_fill,
          iconColor: AppColors.textSecondary,
          iconBackground: AppColors.surfaceMuted,
          showChevron: false,
          showDivider: false,
        );
      },
    );
  }
}
