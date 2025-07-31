import 'package:dartz/dartz.dart';
import 'package:flutter_user/core/errors/failures.dart';
import 'package:flutter_user/features/available_doctors_screen/data/models/available_doctor_model.dart';

abstract class AvailableDoctorsRepository {
  Future<Either<Failure, AvailableDoctor>> getAvailableDoctors(int page);
}
