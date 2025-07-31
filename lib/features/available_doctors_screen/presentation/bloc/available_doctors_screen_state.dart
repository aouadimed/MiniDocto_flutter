part of 'available_doctors_screen_bloc.dart';

@immutable
abstract class AvailableDoctorsScreenState extends Equatable {
  const AvailableDoctorsScreenState();

  @override
  List<Object?> get props => [];
}

class AvailableDoctorsScreenInitial extends AvailableDoctorsScreenState {}

class AvailableDoctorsScreenLoading extends AvailableDoctorsScreenState {}

class AvailableDoctorsScreenFailure extends AvailableDoctorsScreenState {
  final bool isIntentFailure;
  final String message;

  const AvailableDoctorsScreenFailure({
    required this.isIntentFailure,
    required this.message,
  });

  @override
  List<Object?> get props => [isIntentFailure, message];
}

class AvailableDoctorsScreenSuccess extends AvailableDoctorsScreenState {
  
}

class AvailableDoctorsScreenLoaded extends AvailableDoctorsScreenState {
  final AvailableDoctor availableDoctor;

  const AvailableDoctorsScreenLoaded({required this.availableDoctor});

  @override
  List<Object?> get props => [availableDoctor]; 
}
