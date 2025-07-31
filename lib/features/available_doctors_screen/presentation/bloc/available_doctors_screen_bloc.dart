import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user/core/errors/functions.dart';
import 'package:flutter_user/core/errors/failures.dart';
import 'package:flutter_user/features/available_doctors_screen/data/models/available_doctor_model.dart';
import 'package:flutter_user/features/available_doctors_screen/domain/usecases/get_available_doctors_usecase.dart';

part 'available_doctors_screen_event.dart';
part 'available_doctors_screen_state.dart';

class AvailableDoctorsScreenBloc
    extends Bloc<AvailableDoctorsScreenEvent, AvailableDoctorsScreenState> {
  final GetAvailableDoctorsUsecase getAvailableDoctorsUsecase;

  AvailableDoctorsScreenBloc({required this.getAvailableDoctorsUsecase})
    : super(AvailableDoctorsScreenInitial()) {
    on<GetAvailableDoctorsEvent>(_onGetAvailableDoctorsEvent);
  }

  Future<void> _onGetAvailableDoctorsEvent(
    GetAvailableDoctorsEvent event,
    Emitter<AvailableDoctorsScreenState> emit,
  ) async {
    emit(AvailableDoctorsScreenLoading());

    final result = await getAvailableDoctorsUsecase.call(
      GetAvailableDoctorsParams(page: event.page),
    );

    result.fold(
      (failure) => emit(
        AvailableDoctorsScreenFailure(
          message: mapFailureToMessage(failure),
          isIntentFailure: failure is ConnexionFailure,
        ),
      ),
      (availableDoctors) =>
          emit(AvailableDoctorsScreenLoaded(availableDoctor: availableDoctors)),
    );
  }
}
