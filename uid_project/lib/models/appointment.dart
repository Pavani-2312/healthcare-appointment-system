class Appointment {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String patientName;
  final String patientAge;
  final String patientGender;
  final String phone;
  final String reason;
  final DateTime appointmentDate;
  final String timeSlot;
  final AppointmentStatus status;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.phone,
    required this.reason,
    required this.appointmentDate,
    required this.timeSlot,
    this.status = AppointmentStatus.upcoming,
  });

  /// Returns a copy with an updated status
  Appointment copyWith({AppointmentStatus? status}) {
    return Appointment(
      id: id,
      doctorId: doctorId,
      doctorName: doctorName,
      doctorSpecialty: doctorSpecialty,
      patientName: patientName,
      patientAge: patientAge,
      patientGender: patientGender,
      phone: phone,
      reason: reason,
      appointmentDate: appointmentDate,
      timeSlot: timeSlot,
      status: status ?? this.status,
    );
  }
}

enum AppointmentStatus { upcoming, completed, cancelled }
