import 'dart:convert';

enum GeminiErrorKind {
  noApiKey,
  unauthorized,
  billing,
  rateLimit,
  imageRecitation,
  badRequest,
  server,
  network,
  unknown,
}

class GeminiApiException implements Exception {
  GeminiApiException({
    required this.message,
    required this.kind,
    this.statusCode,
  });

  final String message;
  final GeminiErrorKind kind;
  final int? statusCode;

  @override
  String toString() => message;

  static GeminiApiException fromHttp({
    required int statusCode,
    required String body,
  }) {
    final lowerBody = body.toLowerCase();
    final kind = switch (statusCode) {
      401 => GeminiErrorKind.unauthorized,
      403 when lowerBody.contains('billing') ||
          lowerBody.contains('permission') ||
          lowerBody.contains('quota') ||
          lowerBody.contains('blocked') ||
          lowerBody.contains('generativelanguage.googleapis.com') =>
        GeminiErrorKind.billing,
      403 => GeminiErrorKind.billing,
      429 => GeminiErrorKind.rateLimit,
      400 when lowerBody.contains('image_recitation') ||
          lowerBody.contains('recitation') =>
        GeminiErrorKind.imageRecitation,
      400 => GeminiErrorKind.badRequest,
      >= 500 => GeminiErrorKind.server,
      _ => GeminiErrorKind.unknown,
    };

    var message = 'HTTP $statusCode';
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final error = decoded['error'];
        if (error is Map<String, dynamic>) {
          message = error['message'] as String? ?? message;
        }
      }
    } catch (_) {}

    return GeminiApiException(
      message: message,
      kind: kind,
      statusCode: statusCode,
    );
  }

  static GeminiApiException noApiKey(String backend) {
    return GeminiApiException(
      message: 'No $backend API key available',
      kind: GeminiErrorKind.noApiKey,
    );
  }
}
