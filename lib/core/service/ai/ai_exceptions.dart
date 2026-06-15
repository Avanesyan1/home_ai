class AiServiceException implements Exception {
  AiServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
