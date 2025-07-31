import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String id;
  final String doctorId;
  final String patientId;
  final String slotId;
  final String status;
  final DateTime startTime;
  final DateTime endTime;
  final String doctorName;
  final String doctorSpecialty;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.slotId,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        doctorId,
        patientId,
        slotId,
        status,
        startTime,
        endTime,
        doctorName,
        doctorSpecialty,
        createdAt,
        updatedAt,
      ];
}

class AppointmentsResponse extends Equatable {
  final List<Appointment> appointments;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  const AppointmentsResponse({
    required this.appointments,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [
        appointments,
        totalCount,
        currentPage,
        totalPages,
        hasNextPage,
      ];
}
