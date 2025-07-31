import 'package:dartz/dartz.dart';
import 'package:flutter_user/core/errors/failures.dart';
import 'package:flutter_user/core/network/network_info.dart';
import '../../domain/entities/booking_request.dart';
import '../../domain/repository/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, BookingResponse>> bookAppointment({
    required String doctorId,
    required String slotId,
  }) async {
    if (await networkInfo.isConnected == false) {
      return Left(ConnexionFailure());
    }

    try {
      final response = await remoteDataSource.bookAppointment(
        doctorId: doctorId,
        slotId: slotId,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
