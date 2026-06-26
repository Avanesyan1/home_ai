import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:typed_data';

import 'package:home_ai/data/models/gemini_remote_config.dart';
import 'package:home_ai/data/services/gemini_api_exception.dart';
import 'package:http/http.dart' as http;

class GeminiHttpClient {
  GeminiHttpClient._();

  static final GeminiHttpClient instance = GeminiHttpClient._();

  static const _vertexExpressBaseUrl = 'https://aiplatform.googleapis.com';

  Future<Map<String, dynamic>> postVertex({
    required String model,
    required Map<String, dynamic> requestBody,
    required Future<String?> Function() nextVertexKey,
    required GeminiVertexSettings vertex,
  }) async {
    final apiKey = await nextVertexKey();
    if (apiKey == null || apiKey.isEmpty) {
      dev.log('GeminiHttp: Vertex request blocked — no API key');
      throw GeminiApiException.noApiKey('Vertex');
    }

    dev.log(
      'GeminiHttp: Vertex POST model=$model '
      'key=${_maskApiKey(apiKey)} endpoint=${vertex.projectId.isEmpty ? "express" : "project"}',
    );

    final uri = vertex.projectId.isNotEmpty
        ? Uri.parse(
            '$_vertexExpressBaseUrl/v1/projects/${vertex.projectId}/locations/'
            '${vertex.location.isEmpty ? 'global' : vertex.location}/publishers/google/models/'
            '$model:generateContent?key=$apiKey',
          )
        : Uri.parse(
            '$_vertexExpressBaseUrl/v1/publishers/google/models/'
            '$model:generateContent?key=$apiKey',
          );

    return _send(
      uri: uri,
      body: _toRequestJson(requestBody),
      apiKey: apiKey,
    );
  }

  Future<Map<String, dynamic>> _send({
    required Uri uri,
    required Map<String, dynamic> body,
    required String apiKey,
  }) async {
    http.Response response;
    try {
      response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey,
        },
        body: jsonEncode(body),
      );
    } catch (error) {
      throw GeminiApiException(
        message: error.toString(),
        kind: GeminiErrorKind.network,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      throw GeminiApiException(
        message: 'Invalid JSON response',
        kind: GeminiErrorKind.unknown,
      );
    }

    dev.log(
      'GeminiHttp: request failed status=${response.statusCode} '
      'key=${_maskApiKey(apiKey)} body=${response.body.length > 200 ? '${response.body.substring(0, 200)}...' : response.body}',
    );

    throw GeminiApiException.fromHttp(
      statusCode: response.statusCode,
      body: response.body,
    );
  }

  static String _maskApiKey(String key) {
    final trimmed = key.trim();
    if (trimmed.isEmpty) {
      return '<empty>';
    }
    if (trimmed.length <= 8) {
      return '<len=${trimmed.length}>';
    }
    return '${trimmed.substring(0, 4)}...${trimmed.substring(trimmed.length - 4)}';
  }

  Map<String, dynamic> _toRequestJson(Map<String, dynamic> body) {
    final converted = _convertValue(body);
    if (converted is! Map<String, dynamic>) {
      return body;
    }

    _ensureUserRoles(converted);
    return converted;
  }

  void _ensureUserRoles(Map<String, dynamic> body) {
    final contents = body['contents'];
    if (contents is! List) {
      return;
    }

    body['contents'] = contents.map((item) {
      if (item is! Map<String, dynamic>) {
        return item;
      }

      final copy = Map<String, dynamic>.from(item);
      final role = copy['role'] as String?;
      if (role == 'assistant') {
        copy['role'] = 'model';
      } else if (role == null || role.isEmpty) {
        copy['role'] = 'user';
      }
      return copy;
    }).toList();
  }

  dynamic _convertValue(dynamic value) {
    if (value is Map) {
      return value.map(
        (key, nested) =>
            MapEntry(_toCamelCase(key.toString()), _convertValue(nested)),
      );
    }

    if (value is List) {
      return value.map(_convertValue).toList();
    }

    return value;
  }

  String _toCamelCase(String key) {
    if (!key.contains('_')) {
      return key;
    }

    final parts = key.split('_');
    return parts.first +
        parts.skip(1).map((part) {
          if (part.isEmpty) {
            return '';
          }
          return part[0].toUpperCase() + part.substring(1);
        }).join();
  }

  void logEmptyImageResponse(String backend, Map<String, dynamic> json) {
    dev.log('GeminiHttp: $backend HTTP OK but no image — ${describeResponse(json)}');
  }

  String describeResponse(Map<String, dynamic> json) {
    final candidates = json['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      final error = json['error'];
      if (error != null) {
        return 'error=$error';
      }
      return 'no candidates';
    }

    final first = candidates.first;
    if (first is! Map<String, dynamic>) {
      return 'invalid candidate';
    }

    final finishReason = first['finishReason'] ?? first['finish_reason'];
    final content = first['content'];
    if (content is! Map<String, dynamic>) {
      return 'finishReason=$finishReason, no content';
    }

    final parts = content['parts'];
    if (parts is! List) {
      return 'finishReason=$finishReason, no parts';
    }

    final partTypes = parts.map((part) {
      if (part is! Map<String, dynamic>) {
        return 'unknown';
      }
      if (part.containsKey('inlineData') || part.containsKey('inline_data')) {
        return 'inlineData';
      }
      if (part.containsKey('text')) {
        final text = part['text'] as String? ?? '';
        final preview =
            text.length > 80 ? '${text.substring(0, 80)}...' : text;
        return 'text("$preview")';
      }
      return part.keys.join(',');
    }).join('; ');

    return 'finishReason=$finishReason, parts=[$partTypes]';
  }

  String? extractTextFromResponse(Map<String, dynamic> json) {
    final candidates = json['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      return null;
    }

    final firstCandidate = candidates.first;
    if (firstCandidate is! Map<String, dynamic>) {
      return null;
    }

    final content = firstCandidate['content'];
    if (content is! Map<String, dynamic>) {
      return null;
    }

    final parts = content['parts'];
    if (parts is! List<dynamic>) {
      return null;
    }

    for (final part in parts) {
      if (part is Map<String, dynamic>) {
        final text = part['text'];
        if (text is String && text.isNotEmpty) {
          return text;
        }
      }
    }

    return null;
  }

  Uint8List? extractImageBase64FromResponse(Map<String, dynamic> json) {
    final candidates = json['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      return null;
    }

    for (final candidate in candidates) {
      if (candidate is! Map<String, dynamic>) {
        continue;
      }

      final finishReason = candidate['finishReason'] as String? ??
          candidate['finish_reason'] as String?;
      if (finishReason == 'IMAGE_RECITATION' ||
          finishReason == 'SAFETY' ||
          finishReason == 'RECITATION') {
        continue;
      }

      final content = candidate['content'];
      if (content is! Map<String, dynamic>) {
        continue;
      }

      final parts = content['parts'];
      if (parts is! List<dynamic>) {
        continue;
      }

      for (final part in parts) {
        if (part is! Map<String, dynamic>) {
          continue;
        }

        final inlineData = part['inlineData'] ?? part['inline_data'];
        if (inlineData is! Map<String, dynamic>) {
          continue;
        }

        final base64Response = inlineData['data'];
        if (base64Response is String && base64Response.isNotEmpty) {
          return base64Decode(base64Response);
        }
      }
    }

    return null;
  }
}
