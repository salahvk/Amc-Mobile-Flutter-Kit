class APIException implements Exception {
  final String? message;
  final String _prefix;

  APIException([this.message, this._prefix = "APIException"]);

  @override
  String toString() {
    return "$_prefix$message";
  }
}

class ErrorResponseException extends APIException {
  ErrorResponseException({
    required String? message,
    required this.code,
    this.data,
  }) : super(message, "ErrorResponseException: ");

  final int? code;
  final Map<String, dynamic>? data;
}

class ServerException extends APIException {
  ServerException([String? message]) : super(message, "ServerException : ");
}

class UnauthorizedException extends APIException {
  UnauthorizedException([String? message])
      : super(message, "UnauthorizedException : ");
}

class InternetException extends APIException {
  InternetException([String? message]) : super(message, "InternetException : ");
}
