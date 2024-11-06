import 'package:logger/logger.dart' as package_logger;

enum LogType { debug, info, warning, error }

class Logger {
  static LogType _logLevel = LogType.debug; // Up to which level to log
  static bool _isLoggingEnabled = false;

  static void enableLogging() {
    _isLoggingEnabled = true;
  }

  static void disableLogging() {
    _isLoggingEnabled = false;
  }

  static void setLogLevel(LogType logType) {
    _logLevel = logType;
  }

  static void debug(String message) {
    _log(LogType.debug, message);
  }

  static void info(String message) {
    _log(LogType.info, message);
  }

  static void warning(String message) {
    _log(LogType.warning, message);
  }

  static void error(message, {Object? error, StackTrace? stackTrace}) {
    _log(LogType.error, message);
  }

  static void _log(LogType logType, String message) {
    if (logType.index >= _logLevel.index) {
      try {
        final frame = StackTrace.current.toString().split("\n")[2];
        String formattedMessage =
            '[${DateTime.now()}] [${_logLevelToString(logType)}] ${_getCaller(frame)}: $message';
        if (_isLoggingEnabled) {
          _prettyLog(logType, formattedMessage);
        }
        // Example: sendLogToServer(formattedMessage);
      } catch (e) {
        if (_isLoggingEnabled) {
          _prettyLog(logType, 'Error $e while logging: $message');
        }
      }
    }
  }

  static String _logLevelToString(LogType logType) {
    switch (logType) {
      case LogType.debug:
        return 'DEBUG';
      case LogType.info:
        return 'INFO';
      case LogType.warning:
        return 'WARNING';
      case LogType.error:
        return 'ERROR';
      default:
        return '';
    }
  }

  static String _getCaller(String frame) {
    final index = frame.indexOf(" (");
    return frame.substring(index + 2, frame.length - 1);
  }

  static _prettyLog(LogType logType, String message) {
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
        _prettyLogger.e(message);
        break;
    }
  }

  static final _prettyLogger = package_logger.Logger(
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: package_logger.PrettyPrinter(
      methodCount: 0,
      // Number of method calls to be displayed
      errorMethodCount: 8,
      // Number of method calls if stacktrace is provided
      lineLength: 120,
      // Width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: false, // Should each log print contain a timestamp
    ), // Use the PrettyPrinter to format and print log
    output: null, // Use the default LogOutput (-> send everything to console)
  );
}
