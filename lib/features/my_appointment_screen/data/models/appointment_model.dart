import '../../domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.id,
    required super.doctorId,
    required super.patientId,
    required super.slotId,
    required super.status,
    required super.startTime,
    required super.endTime,
    required super.doctorName,
    required super.doctorSpecialty,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      patientId: json['patientId'] as String,
      slotId: json['slotId'] as String,
      status: json['status'] as String,
      startTime: DateTime.parse(json['startTime'] as String).toLocal(),
      endTime: DateTime.parse(json['endTime'] as String).toLocal(),
      doctorName: json['doctorName'] as String,
      doctorSpecialty: json['doctorSpecialty'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'slotId': slotId,
      'status': status,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'doctorName': doctorName,
      'doctorSpecialty': doctorSpecialty,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class AppointmentsResponseModel extends AppointmentsResponse {
  const AppointmentsResponseModel({
    required super.appointments,
    required super.totalCount,
    required super.currentPage,
    required super.totalPages,
    required super.hasNextPage,
  });

  factory AppointmentsResponseModel.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'] as Map<String, dynamic>;

    return AppointmentsResponseModel(
      appointments:
          (json['appointments'] as List<dynamic>)
              .map(
                (appointment) => AppointmentModel.fromJson(
                  appointment as Map<String, dynamic>,
                ),
              )
              .toList(),
      totalCount: json['totalCount'] as int,
      currentPage: pagination['currentPage'] as int,
      totalPages: pagination['totalPages'] as int,
      hasNextPage: pagination['hasNextPage'] as bool,
    );
  }
}
