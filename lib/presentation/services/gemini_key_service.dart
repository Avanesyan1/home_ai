import 'dart:convert';
import 'dart:developer' as dev;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:home_ai/core/config/ai_config.dart';
import 'package:home_ai/data/models/gemini_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeminiKeyService {
  GeminiKeyService._();

  static final GeminiKeyService instance = GeminiKeyService._();

  static const vertexRemoteConfigKey = 'vertex_ai_keys';
  static const _vertexIndexKey = 'vertex_key_index';

  FirebaseRemoteConfig? _remoteConfig;
  SharedPreferences? _prefs;
  GeminiRemoteConfig _config = GeminiRemoteConfig(
    vertex: _localVertexSettings(),
  );

  static GeminiVertexSettings _localVertexSettings() {
    if (AiConfig.localVertexKeys.isEmpty) {
      return GeminiVertexSettings.empty;
    }

    return GeminiVertexSettings(
      enabled: true,
      apiKeys: AiConfig.localVertexKeys,
      projectId: '',
      location: 'global',
    );
  }

  GeminiRemoteConfig get config => _config;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    if (AiConfig.enableFirebaseRemoteConfig && Firebase.apps.isNotEmpty) {
      try {
        _remoteConfig = FirebaseRemoteConfig.instance;
        await _remoteConfig!.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 10),
            minimumFetchInterval: const Duration(minutes: 5),
          ),
        );
        await _remoteConfig!.setDefaults({
          vertexRemoteConfigKey: '',
        });
        await fetchAndActivate();
      } catch (error, stackTrace) {
        dev.log(
          'GeminiKeyService: Remote Config unavailable',
          error: error,
          stackTrace: stackTrace,
        );
      }
    } else if (AiConfig.enableFirebaseRemoteConfig) {
      dev.log('GeminiKeyService: Firebase not initialized, using local keys');
    } else {
      dev.log('GeminiKeyService: Remote Config disabled, using local keys');
    }

    await loadRemoteConfig();
  }

  Future<void> fetchAndActivate() async {
    final remoteConfig = _remoteConfig;
    if (remoteConfig == null) {
      return;
    }

    await remoteConfig.fetchAndActivate();
  }

  Future<GeminiRemoteConfig> loadRemoteConfig() async {
    var vertexRaw = '';

    final remoteConfig = _remoteConfig;
    if (remoteConfig != null) {
      try {
        vertexRaw = remoteConfig.getString(vertexRemoteConfigKey);
      } catch (error) {
        dev.log('GeminiKeyService: read Remote Config failed — $error');
      }
    }

    _config = _parseRemoteConfig(vertexRaw);

    dev.log(
      'vertex_ai_keys → ${_config.vertex.apiKeys.length} '
      'Vertex enabled=${_config.vertex.enabled}',
    );

    return _config;
  }

  Future<String?> nextVertexKey() async {
    final keys = _config.vertex.apiKeys;
    if (!_config.hasVertex || keys.isEmpty) {
      return null;
    }

    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final index = prefs.getInt(_vertexIndexKey) ?? 0;
    final key = keys[index % keys.length];
    await prefs.setInt(_vertexIndexKey, (index + 1) % keys.length);
    dev.log('GeminiKeyService: using Vertex key');
    return key;
  }

  GeminiRemoteConfig _parseRemoteConfig(String vertexRaw) {
    final vertex = vertexRaw.trim().isNotEmpty
        ? _parseVertexSettings(vertexRaw)
        : GeminiVertexSettings.empty;

    final resolvedVertex = vertex.apiKeys.isNotEmpty
        ? vertex
        : _localVertexSettings();

    return GeminiRemoteConfig(vertex: resolvedVertex);
  }

  GeminiVertexSettings _parseVertexSettings(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return GeminiVertexSettings.empty;
    }

    if (trimmed.startsWith('{')) {
      try {
        final json = jsonDecode(trimmed) as Map<String, dynamic>;
        return _vertexFromJson(json);
      } catch (_) {
        return GeminiVertexSettings.empty;
      }
    }

    return GeminiVertexSettings(
      enabled: true,
      apiKeys: [trimmed],
      projectId: '',
      location: 'global',
    );
  }

  GeminiVertexSettings _vertexFromJson(Map<String, dynamic> json) {
    final keys = _readStringList(json['api_keys'] ?? json['vertex_keys']);
    final enabled = json['enabled'] as bool? ?? keys.isNotEmpty;

    return GeminiVertexSettings(
      enabled: enabled && keys.isNotEmpty,
      apiKeys: keys,
      projectId: json['project_id'] as String? ?? '',
      location: json['location'] as String? ?? 'global',
    );
  }

  List<String> _readStringList(Object? value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<String>()
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
