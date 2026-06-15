import 'dart:developer' as dev;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Checks the minimum supported app version from Firebase Remote Config.
///
/// Remote Config key: `min_version` (e.g. "1.2.0"). If the installed app
/// version is lower, [isUpdateRequired] becomes true and the force-update
/// screen must be shown.
class AppUpdateService {
  AppUpdateService._();

  static final AppUpdateService instance = AppUpdateService._();

  static const _minVersionKey = 'min_version';

  bool _isUpdateRequired = false;

  bool get isUpdateRequired => _isUpdateRequired;

  Future<void> check() async {
    if (Firebase.apps.isEmpty) {
      return;
    }

    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await remoteConfig.setDefaults({_minVersionKey: ''});
      await remoteConfig.fetchAndActivate();

      final minVersion = remoteConfig.getString(_minVersionKey).trim();
      if (minVersion.isEmpty) {
        return;
      }

      final info = await PackageInfo.fromPlatform();
      _isUpdateRequired = _isLower(info.version, minVersion);

      dev.log(
        'AppUpdate: current=${info.version}, min=$minVersion, '
        'required=$_isUpdateRequired',
      );
    } catch (error, stackTrace) {
      dev.log(
        'AppUpdate: check failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  bool _isLower(String current, String minimum) {
    final c = _parse(current);
    final m = _parse(minimum);

    for (var i = 0; i < 3; i++) {
      if (c[i] < m[i]) {
        return true;
      }
      if (c[i] > m[i]) {
        return false;
      }
    }
    return false;
  }

  List<int> _parse(String version) {
    final parts = version.split('.');
    return List<int>.generate(3, (index) {
      if (index >= parts.length) {
        return 0;
      }
      return int.tryParse(parts[index].trim()) ?? 0;
    });
  }
}
