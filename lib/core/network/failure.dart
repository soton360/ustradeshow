/// Domain-level failure representation.
abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred. Please try again.', super.statusCode]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Please check your network.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.statusCode]);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Connection timed out. Please try again.']);
}
