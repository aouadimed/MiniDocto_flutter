part of 'available_doctors_screen_bloc.dart';

@immutable
abstract class AvailableDoctorsScreenEvent extends Equatable {
  const AvailableDoctorsScreenEvent();

  @override
  List<Object?> get props => [];
}

class GetAvailableDoctorsEvent extends AvailableDoctorsScreenEvent {
  final int page;

  const GetAvailableDoctorsEvent({required this.page});

  @override
  List<Object?> get props => [page];
}
