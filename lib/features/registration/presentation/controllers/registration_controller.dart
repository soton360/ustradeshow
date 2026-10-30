import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../data/models/registration_request_model.dart';
import '../../data/models/registration_response_model.dart';
import '../../domain/repositories/registration_repository.dart';

enum RegistrationStatus { initial, submitting, success, error }

class RegistrationController extends ChangeNotifier {
  final RegistrationRepository repository;

  RegistrationController({required this.repository});

  final nameController = TextEditingController();
  final designationController = TextEditingController();
  final companyController = TextEditingController();
  late final PhoneController phoneController = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.BD, nsn: ''),
  );
  final emailController = TextEditingController();

  /// Returns the normalized international phone number (e.g. +8801518606399)
  /// ensuring country code is always attached for reliable SMS delivery.
  String? get formattedPhone {
    final phone = phoneController.value;
    if (phone.nsn.trim().isEmpty) return null;
    var nsn = phone.nsn.trim().replaceAll(RegExp(r'\D'), '');
    if (nsn.startsWith('0')) {
      nsn = nsn.replaceFirst(RegExp(r'^0+'), '');
    }
    return '+${phone.countryCode}$nsn';
  }

  /// Resolves the earliest available exhibition day (e.g. if today is Nov 6, defaults to Nov 6).
  static String get initialAvailableDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    const availableDates = ['2026-11-05', '2026-11-06', '2026-11-07'];
    for (final d in availableDates) {
      final parsed = DateTime.parse(d);
      if (!parsed.isBefore(today)) {
        return d;
      }
    }
    return availableDates.last;
  }

  String _ticketType = 'day_visitor'; // 'day_visitor' or 'entire_days_visitor'
  String get ticketType => _ticketType;

  late String _selectedDate = initialAvailableDate;
  String get selectedDate => _selectedDate;

  int _totalPax = 1;
  int get totalPax => _totalPax;

  RegistrationStatus _status = RegistrationStatus.initial;
  RegistrationStatus get status => _status;

  bool get isSubmitting => _status == RegistrationStatus.submitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  RegistrationResponseModel? _lastResponse;
  RegistrationResponseModel? get lastResponse => _lastResponse;

  void setTicketType(String type) {
    if (_ticketType != type) {
      _ticketType = type;
      notifyListeners();
    }
  }

  void setSelectedDate(String date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTotalPax(int pax) {
    _totalPax = pax.clamp(1, 10);
    notifyListeners();
  }

  Future<bool> submitRegistration(List<int> seminarIds) async {
    _status = RegistrationStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = RegistrationRequestModel(
        name: nameController.text.trim(),
        designation: designationController.text.trim().isEmpty
            ? null
            : designationController.text.trim(),
        company: companyController.text.trim(),
        phone: formattedPhone,
        email: emailController.text.trim().toLowerCase(),
        ticketType: _ticketType,
        ticketDate: _ticketType == 'day_visitor' ? _selectedDate : null,
        totalPax: _totalPax,
        seminarIds: seminarIds,
      );

      final response = await repository.registerVisitor(request);
      _lastResponse = response;
      _status = RegistrationStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = RegistrationStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void resetForm() {
    nameController.clear();
    designationController.clear();
    companyController.clear();
    phoneController.value =
        const PhoneNumber(isoCode: IsoCode.BD, nsn: '');
    emailController.clear();
    _ticketType = 'day_visitor';
    _selectedDate = initialAvailableDate;
    _totalPax = 1;
    _status = RegistrationStatus.initial;
    _errorMessage = null;
    _lastResponse = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    designationController.dispose();
    companyController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }
}

