import 'package:flutter/foundation.dart';

class Logger {
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;
  Logger._internal();

  // TODO: Cambiar segun ambiente
  final bool _isDevelopment = true;

  void log(String message, {String? tag, LogLevel level = LogLevel.info}) {
    if (!_isDevelopment) return;

    final timestamp = DateTime.now().toString();
    final formattedMessage = '[$timestamp][${level.name.toUpperCase()}]${tag != null ? '[$tag]' : ''} $message';

    switch (level) {
      case LogLevel.debug:
        debugPrint('🐛 $formattedMessage'); // Debug
        break;
      case LogLevel.info:
        debugPrint('ℹ️ $formattedMessage'); // Info
        break;
      case LogLevel.warning:
        debugPrint('⚠️ $formattedMessage'); // Warning
        break;
      case LogLevel.error:
        debugPrint('❌ $formattedMessage'); // Error
        break;
    }
  }

  void d(String message, {String? tag}) => log(message, tag: tag, level: LogLevel.debug);
  void i(String message, {String? tag}) => log(message, tag: tag, level: LogLevel.info);
  void w(String message, {String? tag}) => log(message, tag: tag, level: LogLevel.warning);
  void e(String message, {String? tag}) => log(message, tag: tag, level: LogLevel.error);
}

enum LogLevel { debug, info, warning, error }
