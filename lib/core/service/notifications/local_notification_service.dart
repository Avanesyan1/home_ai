import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_ai/core/l10n/locale_keys.dart';
import 'package:home_ai/core/logger/app_logger.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        ),
      );

      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      _initialized = true;
      AppLogger.instance.info('Local notifications: initialized');
    } catch (error, stackTrace) {
      AppLogger.instance.error(
        'Local notifications: init failed',
        error,
        stackTrace,
      );
    }
  }

  Future<void> showDesignReady() async {
    if (!_initialized) {
      return;
    }

    const channelId = 'generation_complete';
    const channelName = 'Generation complete';

    try {
      await _plugin.show(
        id: 1,
        title: LocaleKeys.notificationDesignReadyTitle.tr(),
        body: LocaleKeys.notificationDesignReadyBody.tr(),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.instance.error(
        'Local notifications: show failed',
        error,
        stackTrace,
      );
    }
  }

  bool get shouldNotifyOnComplete {
    final state = WidgetsBinding.instance.lifecycleState;
    return state != null && state != AppLifecycleState.resumed;
  }
}
