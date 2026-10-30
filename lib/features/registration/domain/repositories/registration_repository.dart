import '../../data/models/registration_request_model.dart';
import '../../data/models/registration_response_model.dart';
import '../../data/models/seminar_model.dart';

abstract class RegistrationRepository {
  Future<List<Seminar>> getSeminars();
  Future<RegistrationResponseModel> registerVisitor(RegistrationRequestModel request);
}
