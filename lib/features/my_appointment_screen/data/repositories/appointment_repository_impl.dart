import 'package:dartz/dartz.dart';
import 'package:flutter_user/core/network/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repository/appointment_repository.dart';
import '../datasources/appointment_remote_data_source.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AppointmentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AppointmentsResponse>> getMyAppointments({
    required int page,
    int pageSize = 10,
  }) async {
    try {
      if (await networkInfo.isConnected == false) {
        return Left(ConnexionFailure());
      }
      final result = await remoteDataSource.getMyAppointments(
        page: page,
        pageSize: pageSize,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment({
    required String appointmentId,
  }) async {
    try {
      if (await networkInfo.isConnected == false) {
        return Left(ConnexionFailure());
      }
      await remoteDataSource.cancelAppointment(appointmentId: appointmentId);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
