import 'package:equatable/equatable.dart';
import '../../domain/entities/appointment.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<Appointment> appointments;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool isLoadingMore;

  const AppointmentLoaded({
    required this.appointments,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
        appointments,
        totalCount,
        currentPage,
        totalPages,
        hasNextPage,
        isLoadingMore,
      ];

  AppointmentLoaded copyWith({
    List<Appointment>? appointments,
    int? totalCount,
    int? currentPage,
    int? totalPages,
    bool? hasNextPage,
    bool? isLoadingMore,
  }) {
    return AppointmentLoaded(
      appointments: appointments ?? this.appointments,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}

class AppointmentCanceling extends AppointmentState {
  final String appointmentId;

  const AppointmentCanceling(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class AppointmentCancelSuccess extends AppointmentState {
  final String message;

  const AppointmentCancelSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
