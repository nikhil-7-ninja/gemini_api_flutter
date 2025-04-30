/// Exception thrown when generating content fails.
///
/// The [message] may explain the cause of the failure.
final class GenerativeAIException implements Exception {
  final String message;

  GenerativeAIException(this.message);

  @override
  String toString() => 'GenerativeAIException: $message';
}

/// Exception thrown when the server rejects the API key.
final class InvalidApiKey implements GenerativeAIException {
  @override
  final String message;

  InvalidApiKey(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when the user location is unsupported.
final class UnsupportedUserLocation implements GenerativeAIException {
  static const _message = 'User location is not supported for the API use.';
  @override
  String get message => _message;
}

/// Exception thrown when the server failed to generate content.
final class ServerException implements GenerativeAIException {
  @override
  final String message;

  ServerException(this.message);

  @override
  String toString() => message;
}

/// Exception indicating a stale package version or implementation bug.
///
/// This exception indicates a likely problem with the SDK implementation such
/// as an inability to parse a new response format. Resolution paths may include
/// updating to a new version of the SDK, or filing an issue.
final class GenerativeAISdkException implements Exception {
  final String message;

  GenerativeAISdkException(this.message);

  @override
  String toString() => '$message\n'
      'This indicates a problem with the Google Generative AI SDK. '
      'Try updating to the latest version '
      '(https://pub.dev/packages/google_generative_ai/versions), '
      'or file an issue at '
      'https://github.com/google-gemini/generative-ai-dart/issues.';
}

GenerativeAIException parseError(Object jsonObject) {
  return switch (jsonObject) {
    {
      'message': final String message,
      'details': [{'reason': 'API_KEY_INVALID'}, ...]
    } =>
      InvalidApiKey(message),
    {'message': UnsupportedUserLocation._message} => UnsupportedUserLocation(),
    {'message': final String message} => ServerException(message),
    _ => throw unhandledFormat('server error', jsonObject)
  };
}

Exception unhandledFormat(String name, Object? jsonObject) =>
    GenerativeAISdkException('Unhandled format for $name: $jsonObject');
