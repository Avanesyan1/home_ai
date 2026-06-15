class GeminiVertexSettings {
  const GeminiVertexSettings({
    required this.enabled,
    required this.apiKeys,
    required this.projectId,
    required this.location,
  });

  final bool enabled;
  final List<String> apiKeys;
  final String projectId;
  final String location;

  bool get usesExpressEndpoint => projectId.isEmpty;

  GeminiVertexSettings copyWith({
    bool? enabled,
    List<String>? apiKeys,
    String? projectId,
    String? location,
  }) {
    return GeminiVertexSettings(
      enabled: enabled ?? this.enabled,
      apiKeys: apiKeys ?? this.apiKeys,
      projectId: projectId ?? this.projectId,
      location: location ?? this.location,
    );
  }

  static const empty = GeminiVertexSettings(
    enabled: false,
    apiKeys: [],
    projectId: '',
    location: 'global',
  );
}

class GeminiRemoteConfig {
  const GeminiRemoteConfig({
    required this.vertex,
  });

  final GeminiVertexSettings vertex;

  bool get hasVertex => vertex.enabled && vertex.apiKeys.isNotEmpty;

  bool get canGenerate => hasVertex;
}
