import 'dart:convert';
import 'dart:developer' as dev;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:home_ai/core/config/ai_config.dart';
import 'package:home_ai/data/models/gemini_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum VertexKeySource {
  remote,
  local,
  none,
}

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

  VertexKeySource _keySource = VertexKeySource.none;
  String _loadSummary = 'not loaded yet';

  static GeminiVertexSettings _localVertexSettings() {
    final keys = _nonEmptyKeys(AiConfig.localVertexKeys);
    if (keys.isEmpty) {
      return GeminiVertexSettings.empty;
    }

    return GeminiVertexSettings(
      enabled: true,
      apiKeys: keys,
      projectId: '',
      location: 'global',
    );
  }

  GeminiRemoteConfig get config => _config;

  VertexKeySource get keySource => _keySource;

  String describeState() => _loadSummary;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    if (AiConfig.enableFirebaseRemoteConfig && Firebase.apps.isNotEmpty) {
      try {
        _remoteConfig = FirebaseRemoteConfig.instance;
        final projectId = Firebase.app().options.projectId;
        dev.log('GeminiKeyService: Firebase projectId=$projectId');

        await _remoteConfig!.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 15),
            minimumFetchInterval: kDebugMode
                ? Duration.zero
                : const Duration(minutes: 5),
          ),
        );
        await _remoteConfig!.setDefaults({
          vertexRemoteConfigKey: '',
        });
        await _fetchAndLog('init');
      } catch (error, stackTrace) {
        dev.log(
          'GeminiKeyService: Remote Config unavailable — $error',
          error: error,
          stackTrace: stackTrace,
        );
      }
    } else if (AiConfig.enableFirebaseRemoteConfig) {
      dev.log(
        'GeminiKeyService: Firebase not initialized — will use local keys only',
      );
    } else {
      dev.log(
        'GeminiKeyService: Remote Config disabled (enableFirebaseRemoteConfig=false) — local keys only',
      );
      if (AiConfig.apiKey.isEmpty) {
        dev.log(
          'GeminiKeyService: VERTEX_API_KEY dart-define not set',
        );
      } else {
        dev.log(
          'GeminiKeyService: VERTEX_API_KEY dart-define is set '
          '(masked=${_maskApiKey(AiConfig.apiKey)})',
        );
      }
    }

    await loadRemoteConfig();
  }

  Future<void> fetchAndActivate() => _fetchAndLog('manual');

  Future<void> _fetchAndLog(String context) async {
    final remoteConfig = _remoteConfig;
    if (remoteConfig == null) {
      dev.log('GeminiKeyService: fetch skipped ($context) — Remote Config null');
      return;
    }

    try {
      await remoteConfig.fetch();
      final activated = await remoteConfig.activate();
      dev.log(
        'GeminiKeyService: fetch ($context) — '
        'activated=$activated, '
        'lastFetchStatus=${remoteConfig.lastFetchStatus}, '
        'lastFetchTime=${remoteConfig.lastFetchTime}',
      );
      _logRemoteConfigKeys(remoteConfig);
    } catch (error, stackTrace) {
      dev.log(
        'GeminiKeyService: fetch failed ($context) — $error',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _logRemoteConfigKeys(FirebaseRemoteConfig remoteConfig) {
    final all = remoteConfig.getAll();
    final names = all.keys.toList()..sort();
    dev.log(
      'GeminiKeyService: Remote Config parameters (${names.length}): '
      '${names.join(", ")}',
    );

    final vertexEntry = all[vertexRemoteConfigKey];
    if (vertexEntry == null) {
      dev.log(
        'GeminiKeyService: parameter "$vertexRemoteConfigKey" NOT in fetched config — '
        'check Firebase Console → project ${Firebase.app().options.projectId} → Publish',
      );
      return;
    }

    final raw = vertexEntry.asString();
    dev.log(
      'GeminiKeyService: parameter "$vertexRemoteConfigKey" found — '
      'source=${vertexEntry.source}, length=${raw.length}',
    );
  }

  /// Re-fetch from Firebase if keys are missing (e.g. first launch race).
  Future<void> ensureKeysLoaded() async {
    if (_config.canGenerate) {
      return;
    }

    if (_remoteConfig == null) {
      return;
    }

    dev.log('GeminiKeyService: ensureKeysLoaded — retrying fetch');
    await _fetchAndLog('ensure');
    await loadRemoteConfig();
  }

  Future<GeminiRemoteConfig> loadRemoteConfig() async {
    var vertexRaw = '';
    final remoteConfig = _remoteConfig;

    if (remoteConfig != null) {
      try {
        vertexRaw = remoteConfig.getString(vertexRemoteConfigKey);
        dev.log(
          'GeminiKeyService: Remote Config raw '
          'key="$vertexRemoteConfigKey" '
          'length=${vertexRaw.length} '
          'empty=${vertexRaw.trim().isEmpty} '
          'startsWithJson=${vertexRaw.trim().startsWith('{')}',
        );
      } catch (error) {
        dev.log('GeminiKeyService: read Remote Config failed — $error');
      }
    } else {
      dev.log('GeminiKeyService: Remote Config client not available');
    }

    final parseResult = _parseRemoteConfig(vertexRaw);
    _config = parseResult.config;
    _keySource = parseResult.source;
    _loadSummary = parseResult.summary;

    dev.log('GeminiKeyService: $_loadSummary');
    _logResolvedKeys('after load');

    return _config;
  }

  Future<String?> nextVertexKey() async {
    final keys = _nonEmptyKeys(_config.vertex.apiKeys);
    if (!_config.hasVertex || keys.isEmpty) {
      dev.log(
        'GeminiKeyService: no key to use — $_loadSummary',
      );
      return null;
    }

    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final index = prefs.getInt(_vertexIndexKey) ?? 0;
    final key = keys[index % keys.length];
    await prefs.setInt(_vertexIndexKey, (index + 1) % keys.length);

    if (key.isEmpty) {
      dev.log(
        'GeminiKeyService: selected key at index $index is blank — '
        'source=$_keySource, total=${keys.length}',
      );
      return null;
    }

    dev.log(
      'GeminiKeyService: using Vertex key '
      'source=$_keySource '
      'index=$index/${keys.length} '
      'masked=${_maskApiKey(key)} '
      'len=${key.length} '
      'projectId=${_config.vertex.projectId.isEmpty ? "<express>" : _config.vertex.projectId} '
      'location=${_config.vertex.location}',
    );
    return key;
  }

  _ParseResult _parseRemoteConfig(String vertexRaw) {
    final trimmedRaw = vertexRaw.trim();

    if (trimmedRaw.isEmpty) {
      final local = _localVertexSettings();
      final localKeys = _nonEmptyKeys(local.apiKeys);

      if (localKeys.isEmpty) {
        final localConfigured = AiConfig.localVertexKeys.length;
        final reason = localConfigured == 0
            ? 'AiConfig.localVertexKeys is empty'
            : 'AiConfig.apiKey is blank (local list has $localConfigured empty entries)';

        return _ParseResult(
          config: GeminiRemoteConfig(vertex: GeminiVertexSettings.empty),
          source: VertexKeySource.none,
          summary:
              'no keys — Remote Config "$vertexRemoteConfigKey" empty, local fallback failed: $reason',
        );
      }

      dev.log(
        'GeminiKeyService: hint — add VERTEX_API_KEY via '
        '--dart-define=VERTEX_API_KEY=... or set "$vertexRemoteConfigKey" in Firebase Remote Config',
      );

      return _ParseResult(
        config: GeminiRemoteConfig(vertex: local),
        source: VertexKeySource.local,
        summary:
            'keys from local fallback — Remote Config "$vertexRemoteConfigKey" empty, '
            '${localKeys.length} key(s): ${_summarizeKeys(localKeys)}',
      );
    }

    final parsed = _parseVertexSettings(trimmedRaw);
    final parsedKeys = _nonEmptyKeys(parsed.apiKeys);

    if (parsedKeys.isNotEmpty) {
      final vertex = parsed.copyWith(apiKeys: parsedKeys, enabled: true);
      return _ParseResult(
        config: GeminiRemoteConfig(vertex: vertex),
        source: VertexKeySource.remote,
        summary:
            'keys from Remote Config — ${parsedKeys.length} key(s): '
            '${_summarizeKeys(parsedKeys)}, '
            'projectId=${vertex.projectId.isEmpty ? "<express>" : vertex.projectId}, '
            'location=${vertex.location}',
      );
    }

    final local = _localVertexSettings();
    final localKeys = _nonEmptyKeys(local.apiKeys);

    if (localKeys.isEmpty) {
      dev.log(
        'GeminiKeyService: hint — add VERTEX_API_KEY via '
        '--dart-define=VERTEX_API_KEY=... or set "$vertexRemoteConfigKey" in Firebase Remote Config',
      );
      return _ParseResult(
        config: GeminiRemoteConfig(vertex: GeminiVertexSettings.empty),
        source: VertexKeySource.none,
        summary:
            'no keys — Remote Config value present (${trimmedRaw.length} chars) but parse yielded 0 valid keys, '
            'local fallback also empty',
      );
    }

    return _ParseResult(
      config: GeminiRemoteConfig(vertex: local),
      source: VertexKeySource.local,
      summary:
          'keys from local fallback — Remote Config parse failed/empty keys, '
          'using ${localKeys.length} local key(s): ${_summarizeKeys(localKeys)}',
    );
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
      } catch (error) {
        dev.log(
          'GeminiKeyService: JSON parse failed for vertex_ai_keys — $error',
        );
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
      dev.log(
        'GeminiKeyService: api_keys/vertex_keys is not a list '
        '(type=${value.runtimeType})',
      );
      return const [];
    }

    return _nonEmptyKeys(
      value.whereType<String>().map((item) => item.trim()).toList(),
    );
  }

  void _logResolvedKeys(String context) {
    final keys = _nonEmptyKeys(_config.vertex.apiKeys);
    dev.log(
      'GeminiKeyService: resolved keys $context — '
      'source=$_keySource, count=${keys.length}, '
      'enabled=${_config.vertex.enabled}, canGenerate=${_config.canGenerate}',
    );

    if (keys.isEmpty) {
      dev.log('GeminiKeyService: $_loadSummary');
      return;
    }

    for (var i = 0; i < keys.length; i++) {
      dev.log(
        'GeminiKeyService:   [$i] masked=${_maskApiKey(keys[i])} len=${keys[i].length}',
      );
    }
  }

  static List<String> _nonEmptyKeys(List<String> keys) {
    return keys.map((key) => key.trim()).where((key) => key.isNotEmpty).toList();
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

  static String _summarizeKeys(List<String> keys) {
    return keys.map(_maskApiKey).join(', ');
  }
}

class _ParseResult {
  const _ParseResult({
    required this.config,
    required this.source,
    required this.summary,
  });

  final GeminiRemoteConfig config;
  final VertexKeySource source;
  final String summary;
}
