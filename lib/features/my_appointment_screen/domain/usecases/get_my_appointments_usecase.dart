import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_user/core/errors/failures.dart';
import 'package:flutter_user/core/usecases/usecase.dart';
import 'package:flutter_user/features/my_appointment_screen/domain/entities/appointment.dart';
import 'package:flutter_user/features/my_appointment_screen/domain/repository/appointment_repository.dart';

class GetMyAppointmentsUseCase implements UseCase<AppointmentsResponse, GetMyAppointmentsParams> {
  final AppointmentRepository repository;

  GetMyAppointmentsUseCase({required this.repository});

  @override
  Future<Either<Failure, AppointmentsResponse>> call(GetMyAppointmentsParams params) async {
    return await repository.getMyAppointments(
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

class GetMyAppointmentsParams extends Equatable {
  final int page;
  final int pageSize;

  const GetMyAppointmentsParams({
    required this.page,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [page, pageSize];
}
