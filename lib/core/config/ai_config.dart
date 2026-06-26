abstract final class AiConfig {
  /// Fetched from Firebase when true. Requires `vertex_ai_keys` in Remote Config.
  static const bool enableFirebaseRemoteConfig = true;

  /// Local dev: `flutter run --dart-define=VERTEX_API_KEY=your_key`
  /// Do not commit real keys here.
  static const String apiKey = String.fromEnvironment('VERTEX_API_KEY');

  static List<String> get localVertexKeys =>
      apiKey.isEmpty ? const [] : [apiKey];

  static const String imageModel = 'gemini-2.5-flash-image';
  static const String textModel = 'gemini-2.5-flash';

  static const int maxRetries = 2;
  static const Duration retryDelay = Duration(seconds: 1);
}
