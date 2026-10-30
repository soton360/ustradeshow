/// Network and API Exception definitions.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Unable to connect to the server. Please check your internet connection.']);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred. Please try again later.', super.statusCode]);
}

class ValidationException extends AppException {
  const ValidationException(super.message, [super.statusCode]);
}

class TimeoutAppException extends AppException {
  const TimeoutAppException([super.message = 'The connection timed out. Please try again.']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized request.', super.statusCode]);
}
