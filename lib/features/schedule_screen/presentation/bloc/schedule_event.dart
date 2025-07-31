part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class LoadScheduleGroups extends ScheduleEvent {
  final int page;
  final bool isRefresh;
  final String doctorId;

  const LoadScheduleGroups({
    this.page = 0,
    this.isRefresh = false,
    required this.doctorId,
  });

  @override
  List<Object?> get props => [page, isRefresh, doctorId];
}

class SelectScheduleGroup extends ScheduleEvent {
  final String groupId;

  const SelectScheduleGroup(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class SelectTimeSlot extends ScheduleEvent {
  final String slotId;

  const SelectTimeSlot(this.slotId);

  @override
  List<Object?> get props => [slotId];
}

class BookAppointment extends ScheduleEvent {
  final String doctorId;
  final String slotId;

  const BookAppointment({
    required this.doctorId,
    required this.slotId,
  });

  @override
  List<Object?> get props => [doctorId, slotId];
}
