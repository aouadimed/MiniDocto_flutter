import 'package:dartz/dartz.dart';
import 'package:flutter_user/core/errors/failures.dart';
import '../entities/appointment.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, AppointmentsResponse>> getMyAppointments({
    required int page,
    int pageSize = 10,
  });
  
  Future<Either<Failure, void>> cancelAppointment({
    required String appointmentId,
  });
}
