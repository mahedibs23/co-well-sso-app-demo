class BaseException extends Error {
  final String message;
  final int? code;

  BaseException(this.message, {this.code});

  @override
  String toString() {
    return 'BaseException{message: $message, code: $code}';
  }
}
