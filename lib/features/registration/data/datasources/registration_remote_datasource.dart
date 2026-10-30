import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_exceptions.dart';
import '../models/registration_request_model.dart';
import '../models/registration_response_model.dart';
import '../models/seminar_model.dart';

abstract class RegistrationRemoteDataSource {
  Future<List<Seminar>> getSeminars({int limit = 10, int skip = 0});
  Future<RegistrationResponseModel> registerVisitor(RegistrationRequestModel request);
}

class RegistrationRemoteDataSourceImpl implements RegistrationRemoteDataSource {
  final ApiClient apiClient;

  RegistrationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<Seminar>> getSeminars({int limit = 10, int skip = 0}) async {
    final response = await apiClient.get(
      ApiEndpoints.seminarList,
      queryParameters: {
        'limit': limit,
        'skip': skip,
      },
    );

    if (response is Map<String, dynamic> && response['data'] is List) {
      final list = response['data'] as List;
      return list
          .map((item) => Seminar.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw const ServerException('Failed to parse seminar list response');
  }

  @override
  Future<RegistrationResponseModel> registerVisitor(
      RegistrationRequestModel request) async {
    final response = await apiClient.post(
      ApiEndpoints.visitorRegister,
      body: request.toJson(),
    );

    if (response is Map<String, dynamic>) {
      return RegistrationResponseModel.fromJson(response);
    }

    throw const ServerException('Failed to parse registration response');
  }
}

