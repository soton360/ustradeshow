import '../../../../core/network/failure.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/storage/local_ticket_storage.dart';
import '../datasources/registration_remote_datasource.dart';
import '../models/registration_request_model.dart';
import '../models/registration_response_model.dart';
import '../models/seminar_model.dart';
import '../../domain/repositories/registration_repository.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationRemoteDataSource remoteDataSource;

  RegistrationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Seminar>> getSeminars() async {
    try {
      return await remoteDataSource.getSeminars();
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on TimeoutAppException catch (e) {
      throw TimeoutFailure(e.message);
    } on ValidationException catch (e) {
      throw ValidationFailure(e.message, e.statusCode);
    } on ServerException catch (e) {
      throw ServerFailure(e.message, e.statusCode);
    } catch (e) {
      throw ServerFailure('Unable to load seminars: $e');
    }
  }

  @override
  Future<RegistrationResponseModel> registerVisitor(
      RegistrationRequestModel request) async {
    try {
      final response = await remoteDataSource.registerVisitor(request);

      // Persist token if provided
      if (response.token != null && response.token!.isNotEmpty) {
        await LocalTicketStorage.saveToken(response.token!);
      }

      // Persist ticket locally for offline ticket view & quick access
      if (response.data.ticket != null) {
        await LocalTicketStorage.saveTicket({
          'visitor': {
            'id': response.data.id,
            'name': response.data.name,
            'email': response.data.email,
            'phone': response.data.phone,
            'company': response.data.company,
            'designation': response.data.designation,
          },
          'ticket': response.data.ticket!.toJson(),
          'seminars': response.data.seminars.map((s) => s.toJson()).toList(),
          'registered_at': DateTime.now().toIso8601String(),
        });
      }

      return response;
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on TimeoutAppException catch (e) {
      throw TimeoutFailure(e.message);
    } on ValidationException catch (e) {
      throw ValidationFailure(e.message, e.statusCode);
    } on ServerException catch (e) {
      throw ServerFailure(e.message, e.statusCode);
    } catch (e) {
      throw ServerFailure('Registration failed: $e');
    }
  }
}

