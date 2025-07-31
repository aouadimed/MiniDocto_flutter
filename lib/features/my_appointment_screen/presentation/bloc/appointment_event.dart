import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadAppointments extends AppointmentEvent {
  final int page;
  final int pageSize;

  const LoadAppointments({
    this.page = 0,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [page, pageSize];
}

class RefreshAppointments extends AppointmentEvent {}

class LoadMoreAppointments extends AppointmentEvent {}

class CancelAppointment extends AppointmentEvent {
  final String appointmentId;

  const CancelAppointment({required this.appointmentId});

  @override
  List<Object?> get props => [appointmentId];
}
