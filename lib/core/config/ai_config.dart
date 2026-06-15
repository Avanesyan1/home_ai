abstract final class AiConfig {
  /// Set to true after `flutterfire configure` and adding platform config files.
  static const bool enableFirebaseRemoteConfig = false;

  /// Local fallback until Remote Config is enabled. Do not commit real keys.
  static const String apiKey = '';

  static const List<String> localVertexKeys = [apiKey];

  static const String imageModel = 'gemini-2.5-flash-image';
  static const String textModel = 'gemini-2.5-flash';

  static const int maxRetries = 2;
  static const Duration retryDelay = Duration(seconds: 1);
}
