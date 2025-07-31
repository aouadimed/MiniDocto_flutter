import 'package:dartz/dartz.dart';
import 'package:flutter_user/core/errors/failures.dart';
import 'package:flutter_user/core/network/network_info.dart';
import '../../domain/entities/schedule_group.dart';
import '../../domain/repository/schedule_repository.dart';
import '../datasources/schedule_remote_data_source.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ScheduleRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ScheduleGroup>>> getScheduleGroups({
    required int page,
    required int pageSize,
    required String doctorId,
  }) async {
    if (await networkInfo.isConnected == false) {
      return Left(ConnexionFailure());
    }

    try {
      final response = await remoteDataSource.getScheduleGroups(
        page: page,
        pageSize: pageSize,
        doctorId: doctorId,
      );
      return Right(response.scheduleGroups);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
