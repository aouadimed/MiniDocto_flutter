import 'package:dartz/dartz.dart';
import 'package:flutter_user/core/errors/failures.dart';
import 'package:flutter_user/core/network/network_info.dart';
import 'package:flutter_user/features/available_doctors_screen/data/data_source/avaliable_doctors_remote_data_source.dart';
import 'package:flutter_user/features/available_doctors_screen/data/models/available_doctor_model.dart';
import 'package:flutter_user/features/available_doctors_screen/domain/repository/available_doctors_repository.dart';

class AvailableDoctorsRepositoryImpl implements AvailableDoctorsRepository {
  final NetworkInfo networkInfo;

  final AvailableDoctorsRemoteDataSource remoteDataSource;

  AvailableDoctorsRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, AvailableDoctor>> getAvailableDoctors(int page) async {
    if (await networkInfo.isConnected == false) {
      return Left(ConnexionFailure());
    }
    try {
      final remoteDoctor = await remoteDataSource.getAvailableDoctors(page);
      return Right(remoteDoctor);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
