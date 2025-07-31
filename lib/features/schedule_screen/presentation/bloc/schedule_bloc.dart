import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user/core/errors/failures.dart';
import 'package:flutter_user/core/errors/functions.dart';
import '../../domain/entities/schedule_group.dart';
import '../../domain/usecases/get_schedule_groups_usecase.dart';
import '../../domain/usecases/book_appointment_usecase.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetScheduleGroupsUseCase getScheduleGroupsUseCase;
  final BookAppointmentUseCase bookAppointmentUseCase;

  ScheduleBloc({
    required this.getScheduleGroupsUseCase,
    required this.bookAppointmentUseCase,
  }) : super(ScheduleInitial()) {
    on<LoadScheduleGroups>(_onLoadScheduleGroups);
    on<SelectScheduleGroup>(_onSelectScheduleGroup);
    on<SelectTimeSlot>(_onSelectTimeSlot);
    on<BookAppointment>(_onBookAppointment);
  }

  Future<void> _onLoadScheduleGroups(
    LoadScheduleGroups event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      if (event.isRefresh || event.page == 0) {
        emit(ScheduleLoading());
      } else if (state is ScheduleLoaded) {
        emit((state as ScheduleLoaded).copyWith(isLoadingMore: true));
      }

      final result = await getScheduleGroupsUseCase.call(
        GetScheduleGroupsParams(
          page: event.page, 
          pageSize: 30, 
          doctorId: event.doctorId,
        ), // 30 items to ensure proper pagination for 5x2 grid
      );

      result.fold(
        (failure) => emit(ScheduleError(
          message: mapFailureToMessage(failure),
          isNetworkError: failure is ConnexionFailure,
        )),
        (newGroups) {
          if (event.isRefresh || event.page == 0) {
            emit(ScheduleLoaded(
              scheduleGroups: newGroups,
              currentPage: event.page,
              hasMorePages: newGroups.length == 30, // Check for 30 items to ensure proper pagination
              selectedGroupId: newGroups.isNotEmpty ? newGroups.first.id : null, // Auto-select first group
            ));
          } else if (state is ScheduleLoaded) {
            final currentState = state as ScheduleLoaded;
            final updatedGroups = [...currentState.scheduleGroups, ...newGroups];
            emit(currentState.copyWith(
              scheduleGroups: updatedGroups,
              currentPage: event.page,
              hasMorePages: newGroups.length == 30, // Check for 30 items to ensure proper pagination
              isLoadingMore: false,
            ));
          }
        },
      );
    } catch (e) {
      emit(ScheduleError(message: e.toString()));
    }
  }

  void _onSelectScheduleGroup(
    SelectScheduleGroup event,
    Emitter<ScheduleState> emit,
  ) {
    if (state is ScheduleLoaded) {
      final currentState = state as ScheduleLoaded;
      emit(currentState.copyWith(
        selectedGroupId: event.groupId,
        selectedTimeSlotId: null, // Clear time slot selection when group changes
      ));
    }
  }

  void _onSelectTimeSlot(
    SelectTimeSlot event,
    Emitter<ScheduleState> emit,
  ) {
    if (state is ScheduleLoaded) {
      final currentState = state as ScheduleLoaded;
      emit(currentState.copyWith(selectedTimeSlotId: event.slotId));
    }
  }

  Future<void> _onBookAppointment(
    BookAppointment event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(BookingInProgress());

    try {
      final result = await bookAppointmentUseCase.call(
        BookAppointmentParams(
          doctorId: event.doctorId,
          slotId: event.slotId,
        ),
      );

      result.fold(
        (failure) {
          emit(BookingError(message: mapFailureToMessage(failure)));
        },
        (bookingResponse) {
          emit(BookingSuccess(message: bookingResponse.message));
        },
      );
    } catch (e) {
      emit(const BookingError(message: 'An unexpected error occurred'));
    }
  }
}
