import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_user/core/errors/failures.dart';
import 'package:flutter_user/core/usecases/usecase.dart';
import '../entities/schedule_group.dart';
import '../repository/schedule_repository.dart';

class GetScheduleGroupsUseCase extends UseCase<List<ScheduleGroup>, GetScheduleGroupsParams> {
  final ScheduleRepository repository;

  GetScheduleGroupsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ScheduleGroup>>> call(GetScheduleGroupsParams params) async {
    return await repository.getScheduleGroups(
      page: params.page,
      pageSize: params.pageSize,
      doctorId: params.doctorId,
    );
  }
}

class GetScheduleGroupsParams extends Equatable {
  final int page;
  final int pageSize;
  final String doctorId;

  const GetScheduleGroupsParams({
    required this.page,
    required this.doctorId,
    this.pageSize = 30, // Default 30 items per page to ensure proper pagination for 5x2 grid
  });

  @override
  List<Object?> get props => [page, pageSize, doctorId];
}
