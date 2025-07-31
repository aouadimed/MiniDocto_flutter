part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleGroup> scheduleGroups;
  final String? selectedGroupId;
  final String? selectedTimeSlotId;
  final int currentPage;
  final bool hasMorePages;
  final bool isLoadingMore;

  const ScheduleLoaded({
    required this.scheduleGroups,
    this.selectedGroupId,
    this.selectedTimeSlotId,
    required this.currentPage,
    required this.hasMorePages,
    this.isLoadingMore = false,
  });

  ScheduleLoaded copyWith({
    List<ScheduleGroup>? scheduleGroups,
    String? selectedGroupId,
    String? selectedTimeSlotId,
    int? currentPage,
    bool? hasMorePages,
    bool? isLoadingMore,
  }) {
    return ScheduleLoaded(
      scheduleGroups: scheduleGroups ?? this.scheduleGroups,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      selectedTimeSlotId: selectedTimeSlotId ?? this.selectedTimeSlotId,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        scheduleGroups,
        selectedGroupId,
        selectedTimeSlotId,
        currentPage,
        hasMorePages,
        isLoadingMore,
      ];
}

class ScheduleError extends ScheduleState {
  final String message;
  final bool isNetworkError;

  const ScheduleError({
    required this.message,
    this.isNetworkError = false,
  });

  @override
  List<Object?> get props => [message, isNetworkError];
}

class BookingInProgress extends ScheduleState {
  @override
  List<Object?> get props => [];
}

class BookingSuccess extends ScheduleState {
  final String message;

  const BookingSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class BookingError extends ScheduleState {
  final String message;

  const BookingError({required this.message});

  @override
  List<Object?> get props => [message];
}
