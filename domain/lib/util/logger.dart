import 'package:logger/logger.dart' as package_logger;

enum LogType { debug, info, warning, error }

class Logger {
  static LogType _logLevel = LogType.debug; // Define log level threshold
  static bool _isLoggingEnabled = false;

  /// Enables logging
  static void enableLogging() => _isLoggingEnabled = true;

  /// Disables logging
  static void disableLogging() => _isLoggingEnabled = false;

  /// Sets the minimum log level
  static void setLogLevel(LogType logType) => _logLevel = logType;

  /// Logs a debug message
  static void debug(String message, {bool prettyPrint = false}) {
    _log(LogType.debug, message, prettyPrint);
  }

  /// Logs an info message
  static void info(String message, {bool prettyPrint = false}) {
    _log(LogType.info, message, prettyPrint);
  }

  /// Logs a warning message
  static void warning(String message, {bool prettyPrint = false}) {
    _log(LogType.warning, message, prettyPrint);
  }

  /// Logs an error message with optional error details and stack trace
  static void error(
    String message, {
    bool prettyPrint = false,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogType.error, message, prettyPrint,
        error: error, stackTrace: stackTrace);
  }

  /// Internal logging function with enhanced error handling
  static void _log(
    LogType logType,
    String message,
    bool prettyPrint, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_isLoggingEnabled && logType.index >= _logLevel.index) {
      try {
        final frame = StackTrace.current.toString().split('\n')[2];
        final caller = _getCaller(frame);
        final logMessage = '[${_logLevelToString(logType)}] $caller: $message';

        if (prettyPrint) {
          _prettyLog(logType, logMessage, error: error, stackTrace: stackTrace);
        } else {
          print(logMessage);
        }

        // Optional: Add code to send logs to a server or a file.
      } catch (e) {
        print('Error during logging: $e');
      }
    }
  }

  /// Converts LogType enum to string for readability
  static String _logLevelToString(LogType logType) =>
      logType.toString().split('.').last.toUpperCase();

  /// Extracts the caller from the stack trace for context
  static String _getCaller(String frame) {
    final index = frame.indexOf(' (');
    return (index != -1)
        ? frame.substring(index + 2, frame.length - 1)
        : 'Unknown';
  }

  /// Logs with PrettyPrinter when `prettyPrint` is enabled
  static void _prettyLog(
    LogType logType,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    switch (logType) {
      case LogType.debug:
        _prettyLogger.d(message);
        break;
      case LogType.info:
        _prettyLogger.i(message);
        break;
      case LogType.warning:
        _prettyLogger.w(message);
        break;
      case LogType.error:
        _prettyLogger.e(error: error, stackTrace);
        break;
    }
  }

  /// Configure PrettyPrinter with customization options
  static final package_logger.Logger _prettyLogger = package_logger.Logger(
    printer: package_logger.PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );
}
