import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_user/core/errors/failures.dart';
import 'package:flutter_user/core/usecases/usecase.dart';
import '../entities/booking_request.dart';
import '../repository/booking_repository.dart';

class BookAppointmentUseCase implements UseCase<BookingResponse, BookAppointmentParams> {
  final BookingRepository repository;

  BookAppointmentUseCase({required this.repository});

  @override
  Future<Either<Failure, BookingResponse>> call(BookAppointmentParams params) async {
    return await repository.bookAppointment(
      doctorId: params.doctorId,
      slotId: params.slotId,
    );
  }
}

class BookAppointmentParams extends Equatable {
  final String doctorId;
  final String slotId;

  const BookAppointmentParams({
    required this.doctorId,
    required this.slotId,
  });

  @override
  List<Object?> get props => [doctorId, slotId];
}
