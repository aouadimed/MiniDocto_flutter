import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_user/core/errors/failures.dart';
import 'package:flutter_user/core/usecases/usecase.dart';
import 'package:flutter_user/features/available_doctors_screen/data/models/available_doctor_model.dart';
import 'package:flutter_user/features/available_doctors_screen/domain/repository/available_doctors_repository.dart';

class GetAvailableDoctorsUsecase extends UseCase<AvailableDoctor, GetAvailableDoctorsParams> {
  final AvailableDoctorsRepository repository;

  GetAvailableDoctorsUsecase({required this.repository});

  @override
  Future<Either<Failure, AvailableDoctor>> call(GetAvailableDoctorsParams params) async {
    return await repository.getAvailableDoctors(params.page);
  }
}

class GetAvailableDoctorsParams extends Equatable {
  final int page;

  const GetAvailableDoctorsParams({required this.page});

  @override
  List<Object?> get props => [page];
}
