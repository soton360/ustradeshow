/// API configuration & endpoints for U.S. Trade Show 2026.
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://10.10.220.45:4444/api/v1';
  // static const String baseUrl = 'https://amcham-server.m360ictapi.com/api/v1';

  // Visitor Endpoints
  static const String seminarList = '$baseUrl/visitor/seminar';
  static const String visitorRegister = '$baseUrl/visitor/register';

  // Request Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
}

