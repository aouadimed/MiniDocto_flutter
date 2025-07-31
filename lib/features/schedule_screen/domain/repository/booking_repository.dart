import 'package:dartz/dartz.dart';
import 'package:flutter_user/core/errors/failures.dart';
import '../entities/booking_request.dart';

abstract class BookingRepository {
  Future<Either<Failure, BookingResponse>> bookAppointment({
    required String doctorId,
    required String slotId,
  });
}
