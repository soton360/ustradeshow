import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import 'network_exceptions.dart';

/// Clean wrapper around http.Client with automatic header injection,
/// robust error mapping, and timeout management.
class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _defaultHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<dynamic> get(
    String url, {
    Map<String, String>? headers,
    String? token,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var uri = Uri.parse(url);
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = uri.replace(
          queryParameters: {
            ...uri.queryParameters,
            ...queryParameters.map((k, v) => MapEntry(k, v.toString())),
          },
        );
      }

      final mergedHeaders = {..._defaultHeaders(token: token), ...?headers};

      final response = await _client
          .get(uri, headers: mergedHeaders)
          .timeout(ApiEndpoints.connectTimeout);

      return _processResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const TimeoutAppException();
    } on FormatException catch (e) {
      throw ValidationException('Invalid data format: ${e.message}');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Unexpected network error: $e');
    }
  }

  Future<dynamic> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final uri = Uri.parse(url);
      final mergedHeaders = {..._defaultHeaders(token: token), ...?headers};
      final encodedBody = body is String ? body : jsonEncode(body);

      final response = await _client
          .post(uri, headers: mergedHeaders, body: encodedBody)
          .timeout(ApiEndpoints.receiveTimeout);

      return _processResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const TimeoutAppException();
    } on FormatException catch (e) {
      throw ValidationException('Invalid response format: ${e.message}');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Unexpected network error: $e');
    }
  }

  dynamic _processResponse(http.Response response) {
    final bodyString = response.body;
    dynamic jsonBody;
    try {
      jsonBody = bodyString.isNotEmpty ? jsonDecode(bodyString) : null;
    } catch (_) {
      jsonBody = null;
    }

    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      return jsonBody;
    }

    final message = (jsonBody is Map && jsonBody['message'] != null)
        ? jsonBody['message'].toString()
        : 'Request failed with status $statusCode';

    switch (statusCode) {
      case 400:
      case 422:
        throw ValidationException(message, statusCode);
      case 401:
      case 403:
        throw UnauthorizedException(message, statusCode);
      case 404:
        throw ServerException(message, statusCode);
      case 500:
      case 502:
      case 503:
      default:
        throw ServerException(message, statusCode);
    }
  }

  void close() {
    _client.close();
  }
}

