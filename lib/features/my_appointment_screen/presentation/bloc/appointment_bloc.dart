import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_appointments_usecase.dart';
import '../../domain/usecases/cancel_appointment_usecase.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetMyAppointmentsUseCase getMyAppointmentsUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;

  AppointmentBloc({
    required this.getMyAppointmentsUseCase,
    required this.cancelAppointmentUseCase,
  }) : super(AppointmentInitial()) {
    on<LoadAppointments>(_onLoadAppointments);
    on<RefreshAppointments>(_onRefreshAppointments);
    on<LoadMoreAppointments>(_onLoadMoreAppointments);
    on<CancelAppointment>(_onCancelAppointment);
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(AppointmentLoading());

    final result = await getMyAppointmentsUseCase(
      GetMyAppointmentsParams(
        page: event.page,
        pageSize: event.pageSize,
      ),
    );

    result.fold(
      (failure) => emit(const AppointmentError('Failed to load appointments')),
      (appointmentsResponse) => emit(
        AppointmentLoaded(
          appointments: appointmentsResponse.appointments,
          totalCount: appointmentsResponse.totalCount,
          currentPage: appointmentsResponse.currentPage,
          totalPages: appointmentsResponse.totalPages,
          hasNextPage: appointmentsResponse.hasNextPage,
        ),
      ),
    );
  }

  Future<void> _onRefreshAppointments(
    RefreshAppointments event,
    Emitter<AppointmentState> emit,
  ) async {
    add(const LoadAppointments(page: 0, pageSize: 10));
  }

  Future<void> _onLoadMoreAppointments(
    LoadMoreAppointments event,
    Emitter<AppointmentState> emit,
  ) async {
    if (state is AppointmentLoaded) {
      final currentState = state as AppointmentLoaded;
      
      if (!currentState.hasNextPage || currentState.isLoadingMore) {
        return;
      }

      emit(currentState.copyWith(isLoadingMore: true));

      final result = await getMyAppointmentsUseCase(
        GetMyAppointmentsParams(
          page: currentState.currentPage + 1,
          pageSize: 10,
        ),
      );

      result.fold(
        (failure) => emit(currentState.copyWith(isLoadingMore: false)),
        (appointmentsResponse) {
          final updatedAppointments = [
            ...currentState.appointments,
            ...appointmentsResponse.appointments,
          ];

          emit(
            AppointmentLoaded(
              appointments: updatedAppointments,
              totalCount: appointmentsResponse.totalCount,
              currentPage: appointmentsResponse.currentPage,
              totalPages: appointmentsResponse.totalPages,
              hasNextPage: appointmentsResponse.hasNextPage,
              isLoadingMore: false,
            ),
          );
        },
      );
    }
  }

  Future<void> _onCancelAppointment(
    CancelAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(AppointmentCanceling(event.appointmentId));

    final result = await cancelAppointmentUseCase(
      CancelAppointmentParams(appointmentId: event.appointmentId),
    );

    result.fold(
      (failure) => emit(const AppointmentError('Failed to cancel appointment')),
      (_) {
        emit(const AppointmentCancelSuccess('Appointment cancelled successfully'));
        // Refresh the appointments list
        add(const LoadAppointments(page: 0, pageSize: 10));
      },
    );
  }
}
