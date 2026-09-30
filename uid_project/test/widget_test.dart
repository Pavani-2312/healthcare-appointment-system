import 'package:flutter_test/flutter_test.dart';
import 'package:uid_project/models/doctor.dart';
import 'package:uid_project/models/appointment.dart';
import 'package:uid_project/models/user_profile.dart';
import 'package:uid_project/providers/appointment_provider.dart';
import 'package:uid_project/providers/doctor_provider.dart';
import 'package:uid_project/providers/profile_provider.dart';

void main() {
  group('Doctor model', () {
    test('sampleDoctors returns 6 doctors', () {
      expect(Doctor.sampleDoctors().length, 6);
    });

    test('each doctor has a non-empty name', () {
      for (final d in Doctor.sampleDoctors()) {
        expect(d.name.isNotEmpty, true);
      }
    });

    test('each doctor has a non-empty specialty', () {
      for (final d in Doctor.sampleDoctors()) {
        expect(d.specialty.isNotEmpty, true);
      }
    });

    test('each doctor has a non-empty education', () {
      for (final d in Doctor.sampleDoctors()) {
        expect(d.education.isNotEmpty, true);
      }
    });

    test('all doctors share the same hospital', () {
      expect(Doctor.hospital, isNotEmpty);
    });
  });

  group('Appointment model', () {
    Appointment makeAppt({String id = 'a1'}) => Appointment(
          id: id,
          doctorId: 'd1',
          doctorName: 'Dr. Test',
          doctorSpecialty: 'General',
          patientName: 'Patient One',
          patientAge: '25',
          patientGender: 'Male',
          phone: '9876543210',
          reason: 'Fever',
          appointmentDate: DateTime(2026, 10, 15),
          timeSlot: '10:00 AM',
        );

    test('default status is upcoming', () {
      expect(makeAppt().status, AppointmentStatus.upcoming);
    });

    test('copyWith updates status', () {
      final cancelled =
          makeAppt().copyWith(status: AppointmentStatus.cancelled);
      expect(cancelled.status, AppointmentStatus.cancelled);
    });

    test('copyWith preserves other fields', () {
      final original = makeAppt();
      final copy = original.copyWith(status: AppointmentStatus.cancelled);
      expect(copy.patientName, original.patientName);
      expect(copy.timeSlot, original.timeSlot);
    });
  });

  group('UserProfile model', () {
    test('defaultProfile has non-empty name', () {
      expect(UserProfile.defaultProfile().name.isNotEmpty, true);
    });

    test('copyWith updates only specified field', () {
      final original = UserProfile.defaultProfile();
      final updated = original.copyWith(name: 'New Name');
      expect(updated.name, 'New Name');
      expect(updated.email, original.email);
    });
  });

  group('AppointmentProvider', () {
    late AppointmentProvider provider;

    setUp(() => provider = AppointmentProvider());

    Appointment makeAppt(String id) => Appointment(
          id: id,
          doctorId: 'd1',
          doctorName: 'Dr. A',
          doctorSpecialty: 'Cardiology',
          patientName: 'Test Patient',
          patientAge: '30',
          patientGender: 'Female',
          phone: '9000000000',
          reason: 'Checkup',
          appointmentDate: DateTime.now().add(const Duration(days: 1)),
          timeSlot: '9:00 AM',
        );

    test('starts empty', () {
      expect(provider.appointments.isEmpty, true);
    });

    test('bookAppointment adds an appointment', () {
      provider.bookAppointment(makeAppt('1'));
      expect(provider.totalCount, 1);
    });

    test('new appointment is upcoming', () {
      provider.bookAppointment(makeAppt('2'));
      expect(provider.upcoming.length, 1);
    });

    test('cancelAppointment changes status to cancelled', () {
      provider.bookAppointment(makeAppt('3'));
      provider.cancelAppointment('3');
      expect(provider.cancelled.length, 1);
      expect(provider.upcoming.length, 0);
    });

    test('totalCount matches booked appointments', () {
      provider.bookAppointment(makeAppt('4'));
      provider.bookAppointment(makeAppt('5'));
      expect(provider.totalCount, 2);
    });
  });

  group('DoctorProvider', () {
    late DoctorProvider provider;

    setUp(() => provider = DoctorProvider());

    test('filteredDoctors returns all by default', () {
      expect(provider.filteredDoctors.length, 6);
    });

    test('search by name filters correctly', () {
      provider.updateSearch('Priya');
      expect(
        provider.filteredDoctors
            .every((d) => d.name.toLowerCase().contains('priya')),
        true,
      );
    });

    test('clearFilters resets results', () {
      provider.updateSearch('xyz');
      provider.clearFilters();
      expect(provider.filteredDoctors.length, 6);
    });

    test('getDoctorById returns correct doctor', () {
      final doctor = provider.getDoctorById('d1');
      expect(doctor, isNotNull);
      expect(doctor!.id, 'd1');
    });

    test('getDoctorById returns null for unknown id', () {
      expect(provider.getDoctorById('unknown'), isNull);
    });

    test('specialties list starts with All', () {
      expect(provider.specialties.first, 'All');
    });
  });

  group('ProfileProvider', () {
    late ProfileProvider provider;

    setUp(() => provider = ProfileProvider());

    test('default profile name is not empty', () {
      expect(provider.profile.name.isNotEmpty, true);
    });

    test('updateProfile persists new data', () {
      final updated = provider.profile.copyWith(name: 'New Name');
      provider.updateProfile(updated);
      expect(provider.profile.name, 'New Name');
    });
  });
}
