import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:typed_data';

import 'package:home_ai/core/config/ai_config.dart';
import 'package:home_ai/data/services/gemini_api_exception.dart';
import 'package:home_ai/data/services/gemini_http_client.dart';
import 'package:home_ai/presentation/services/gemini_key_service.dart';

class GeminiService {
  GeminiService._();

  static final GeminiService instance = GeminiService._();

  final GeminiHttpClient _client = GeminiHttpClient.instance;
  final GeminiKeyService _keys = GeminiKeyService.instance;

  Future<Uint8List> generateImage({
    required String prompt,
    required Uint8List imageBytes,
  }) async {
    final requestBody = _buildImageRequestBody(
      prompt: prompt,
      imageBytes: imageBytes,
    );

    GeminiApiException? lastError;

    for (var attempt = 0; attempt < AiConfig.maxRetries; attempt++) {
      try {
        return await _generateImageOnce(requestBody);
      } on GeminiApiException catch (error) {
        lastError = error;

        if (!_shouldRetry(error) || attempt >= AiConfig.maxRetries - 1) {
          rethrow;
        }

        dev.log(
          'GeminiService: retry ${attempt + 2}/${AiConfig.maxRetries} '
          'after ${error.message}',
        );
        await Future<void>.delayed(AiConfig.retryDelay);
      }
    }

    throw lastError ??
        GeminiApiException(
          message: 'Failed to generate image',
          kind: GeminiErrorKind.unknown,
        );
  }

  Future<Uint8List> _generateImageOnce(Map<String, dynamic> requestBody) async {
    await _keys.ensureKeysLoaded();

    final config = _keys.config;
    if (!config.canGenerate) {
      dev.log(
        'GeminiService: cannot generate — ${_keys.describeState()}',
      );
      throw GeminiApiException.noApiKey('Vertex');
    }

    dev.log('GeminiService: starting image generation — ${_keys.describeState()}');

    final response = await _client.postVertex(
      model: AiConfig.imageModel,
      requestBody: requestBody,
      nextVertexKey: _keys.nextVertexKey,
      vertex: config.vertex,
    );

    final image = _client.extractImageBase64FromResponse(response);
    if (image != null) {
      dev.log('GeminiHttp: Vertex AI OK');
      return image;
    }

    _client.logEmptyImageResponse('Vertex', response);

    final refusal = _client.extractTextFromResponse(response);
    if (refusal != null && refusal.isNotEmpty) {
      throw GeminiApiException(
        message: refusal,
        kind: GeminiErrorKind.badRequest,
      );
    }

    throw GeminiApiException(
      message: 'Vertex returned no image data',
      kind: GeminiErrorKind.unknown,
    );
  }

  Future<bool> testConnection() async {
    try {
      final config = _keys.config;
      if (!config.canGenerate) {
        return false;
      }

      final response = await _client.postVertex(
        model: AiConfig.textModel,
        requestBody: {
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'Hello, please respond with a brief confirmation that you are working.',
                },
              ],
            },
          ],
        },
        nextVertexKey: _keys.nextVertexKey,
        vertex: config.vertex,
      );

      final text = _client.extractTextFromResponse(response);
      return text != null && text.isNotEmpty;
    } catch (error, stackTrace) {
      dev.log(
        'GeminiService: connection test failed',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Map<String, dynamic> _buildImageRequestBody({
    required String prompt,
    required Uint8List imageBytes,
  }) {
    return {
      'contents': [
        {
          'parts': [
            {
              'inline_data': {
                'mime_type': _detectImageMimeType(imageBytes),
                'data': base64Encode(imageBytes),
              },
            },
            {'text': prompt},
          ],
        },
      ],
      'generationConfig': {
        'responseModalities': ['TEXT', 'IMAGE'],
        'candidateCount': 1,
      },
    };
  }

  bool _shouldRetry(GeminiApiException error) {
    return error.kind == GeminiErrorKind.rateLimit ||
        error.kind == GeminiErrorKind.server ||
        error.kind == GeminiErrorKind.network ||
        error.message.toLowerCase().contains('no image');
  }

  static String _detectImageMimeType(Uint8List bytes) {
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'image/png';
    }
    if (bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xD8) {
      return 'image/jpeg';
    }
    return 'image/png';
  }
}
