import 'package:flutter/foundation.dart';
import '../../data/models/seminar_model.dart';
import '../../domain/repositories/registration_repository.dart';

enum SeminarState { initial, loading, loaded, error }

/// Manages seminar fetching, search, and multi-selection state.
class SeminarController extends ChangeNotifier {
  final RegistrationRepository repository;

  SeminarController({required this.repository});

  SeminarState _state = SeminarState.initial;
  SeminarState get state => _state;

  List<Seminar> _seminars = [];
  List<Seminar> get seminars => _seminars;

  final Set<int> _selectedSeminarIds = {};
  Set<int> get selectedSeminarIds => _selectedSeminarIds;

  List<Seminar> get selectedSeminars =>
      _seminars.where((s) => _selectedSeminarIds.contains(s.id)).toList();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == SeminarState.loading;

  Future<void> fetchSeminars({bool refresh = false}) async {
    if (_seminars.isNotEmpty && !refresh) return;

    _state = SeminarState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _seminars = await repository.getSeminars();
      _state = SeminarState.loaded;
    } catch (e) {
      _state = SeminarState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void toggleSeminar(int id) {
    if (_selectedSeminarIds.contains(id)) {
      _selectedSeminarIds.remove(id);
    } else {
      _selectedSeminarIds.add(id);
    }
    notifyListeners();
  }

  void selectSeminar(int id) {
    _selectedSeminarIds.add(id);
    notifyListeners();
  }

  void unselectSeminar(int id) {
    _selectedSeminarIds.remove(id);
    notifyListeners();
  }

  void clearSelection() {
    _selectedSeminarIds.clear();
    notifyListeners();
  }

  bool isSelected(int id) => _selectedSeminarIds.contains(id);
}

