import 'package:flutter/foundation.dart';
import '../models/appointment.dart';

class AppointmentProvider extends ChangeNotifier {
  final List<Appointment> _appointments = [];

  List<Appointment> get appointments => List.unmodifiable(_appointments);

  List<Appointment> get upcoming =>
      _appointments.where((a) => a.status == AppointmentStatus.upcoming).toList();

  List<Appointment> get completed =>
      _appointments.where((a) => a.status == AppointmentStatus.completed).toList();

  List<Appointment> get cancelled =>
      _appointments.where((a) => a.status == AppointmentStatus.cancelled).toList();

  void bookAppointment(Appointment appointment) {
    _appointments.insert(0, appointment);
    notifyListeners();
  }

  void cancelAppointment(String id) {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _appointments[index] =
          _appointments[index].copyWith(status: AppointmentStatus.cancelled);
      notifyListeners();
    }
  }

  int get totalCount => _appointments.length;
}
