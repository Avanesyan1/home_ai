import 'package:url_launcher/url_launcher.dart';

abstract final class LinkLauncher {
  static Future<bool> open(Uri uri) {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
