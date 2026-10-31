import '../../core/network/api_client.dart';
import '../../core/services/app_update_service.dart';
import '../../features/registration/data/datasources/registration_remote_datasource.dart';
import '../../features/registration/data/repositories/registration_repository_impl.dart';
import '../../features/registration/domain/repositories/registration_repository.dart';
import '../../features/registration/presentation/controllers/registration_controller.dart';
import '../../features/registration/presentation/controllers/seminar_controller.dart';

/// Lightweight dependency container / service locator for clean architecture.
class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator instance = ServiceLocator._();

  bool _initialized = false;
  late final ApiClient _apiClient;
  late final RegistrationRemoteDataSource _registrationRemoteDataSource;
  late final RegistrationRepository _registrationRepository;
  late final SeminarController _seminarController;
  late final RegistrationController _registrationController;

  void initialize() {
    if (_initialized) return;
    _apiClient = ApiClient();
    _registrationRemoteDataSource =
        RegistrationRemoteDataSourceImpl(apiClient: _apiClient);
    _registrationRepository = RegistrationRepositoryImpl(
      remoteDataSource: _registrationRemoteDataSource,
    );
    _seminarController = SeminarController(repository: _registrationRepository);
    _registrationController =
        RegistrationController(repository: _registrationRepository);
    _initialized = true;
  }

  void _ensureInitialized() {
    if (!_initialized) {
      initialize();
    }
  }

  ApiClient get apiClient {
    _ensureInitialized();
    return _apiClient;
  }

  RegistrationRemoteDataSource get registrationRemoteDataSource {
    _ensureInitialized();
    return _registrationRemoteDataSource;
  }

  RegistrationRepository get registrationRepository {
    _ensureInitialized();
    return _registrationRepository;
  }

  SeminarController get seminarController {
    _ensureInitialized();
    return _seminarController;
  }

  RegistrationController get registrationController {
    _ensureInitialized();
    return _registrationController;
  }

  AppUpdateService get updateService {
    _ensureInitialized();
    return AppUpdateService.instance;
  }

  void dispose() {
    if (_initialized) {
      _seminarController.dispose();
      _registrationController.dispose();
      _apiClient.close();
      _initialized = false;
    }
  }
}
