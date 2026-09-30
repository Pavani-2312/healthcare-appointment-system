import 'package:flutter/foundation.dart';
import '../models/doctor.dart';
class DoctorProvider extends ChangeNotifier {
  final List<Doctor> _allDoctors = Doctor.sampleDoctors();
  String _searchQuery = '';
  String _selectedSpecialty = 'All';

  List<String> get specialties {
    final specs = _allDoctors.map((d) => d.specialty).toSet().toList()..sort();
    return ['All', ...specs];
  }

  List<Doctor> get filteredDoctors {
    return _allDoctors.where((d) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.specialty.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.education.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesSpecialty =
          _selectedSpecialty == 'All' || d.specialty == _selectedSpecialty;
      return matchesSearch && matchesSpecialty;
    }).toList();
  }

  String get searchQuery => _searchQuery;
  String get selectedSpecialty => _selectedSpecialty;

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateSpecialty(String specialty) {
    _selectedSpecialty = specialty;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedSpecialty = 'All';
    notifyListeners();
  }

  Doctor? getDoctorById(String id) {
    try {
      return _allDoctors.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }
}
