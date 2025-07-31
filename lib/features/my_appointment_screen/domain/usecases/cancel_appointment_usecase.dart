import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_user/core/errors/failures.dart';
import 'package:flutter_user/core/usecases/usecase.dart';
import '../repository/appointment_repository.dart';

class CancelAppointmentUseCase implements UseCase<void, CancelAppointmentParams> {
  final AppointmentRepository repository;

  CancelAppointmentUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CancelAppointmentParams params) async {
    return await repository.cancelAppointment(
      appointmentId: params.appointmentId,
    );
  }
}

class CancelAppointmentParams extends Equatable {
  final String appointmentId;

  const CancelAppointmentParams({
    required this.appointmentId,
  });

  @override
  List<Object?> get props => [appointmentId];
}
