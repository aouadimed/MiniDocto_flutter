import 'package:dartz/dartz.dart';
import 'package:flutter_user/core/errors/failures.dart';
import '../entities/schedule_group.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, List<ScheduleGroup>>> getScheduleGroups({
    required int page,
    required int pageSize,
    required String doctorId,
  });
}
