import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/service/analytics/analytics_service.dart';
import 'package:home_ai/core/utils/link_launcher.dart';

abstract final class SettingsActions {
  static Future<void> openLink(
    BuildContext context,
    Uri uri, {
    required String link,
  }) async {
    unawaited(AnalyticsService.instance.logSettingsLinkOpened(link));
    final opened = await LinkLauncher.open(uri);
    if (opened || !context.mounted) {
      return;
    }

    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(LocaleKeys.commonError.tr()),
        content: Text(LocaleKeys.commonLinkOpenFailed.tr()),
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
}
