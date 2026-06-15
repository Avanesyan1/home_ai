import 'dart:typed_data';

import 'package:home_ai/core/service/ai/ai_exceptions.dart';
import 'package:home_ai/data/services/gemini_api_exception.dart';
import 'package:home_ai/data/services/gemini_service.dart';

class AiService {
  AiService._();

  static final AiService instance = AiService._();

  Future<Uint8List> generateImage({
    required String prompt,
    required Uint8List imageBytes,
  }) {
    return _wrap(() => GeminiService.instance.generateImage(
          prompt: prompt,
          imageBytes: imageBytes,
        ));
  }

  Future<bool> testConnection() {
    return GeminiService.instance.testConnection();
  }

  Future<T> _wrap<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on GeminiApiException catch (error) {
      throw AiServiceException(error.message);
    }
  }
}
