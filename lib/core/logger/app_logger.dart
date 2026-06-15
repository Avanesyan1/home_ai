import 'dart:developer' as dev;

class AppLogger {
  AppLogger._();

  static final AppLogger instance = AppLogger._();

  void info(String message) {
    dev.log(message, name: 'HomeAI');
  }

  void warning(String message) {
    dev.log(message, name: 'HomeAI', level: 900);
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    dev.log(
      message,
      name: 'HomeAI',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
