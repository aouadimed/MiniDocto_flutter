import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_user/features/authentication/data/data_sources/remote_data_source/authentification_remote_data_source.dart';
import 'package:flutter_user/features/authentication/data/repository/user_repository_impl.dart';
import 'package:flutter_user/features/authentication/domain/repository/user_repository.dart';
import 'package:flutter_user/features/authentication/domain/usecases/login_user_use_case.dart';
import 'package:flutter_user/features/authentication/domain/usecases/sign_up_user_use_case.dart';
import 'package:flutter_user/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter_user/features/available_doctors_screen/data/data_source/avaliable_doctors_remote_data_source.dart';
import 'package:flutter_user/features/available_doctors_screen/data/repository/avaliable_doctors_repository_impl.dart';
import 'package:flutter_user/features/available_doctors_screen/domain/repository/available_doctors_repository.dart';
import 'package:flutter_user/features/available_doctors_screen/domain/usecases/get_available_doctors_usecase.dart';
import 'package:flutter_user/features/available_doctors_screen/presentation/bloc/available_doctors_screen_bloc.dart';
import 'package:flutter_user/features/my_appointment_screen/data/repositories/appointment_repository_impl.dart';
import 'package:flutter_user/features/my_appointment_screen/domain/usecases/cancel_appointment_usecase.dart';
import 'package:flutter_user/features/schedule_screen/data/datasources/schedule_remote_data_source.dart';
import 'package:flutter_user/features/schedule_screen/data/datasources/booking_remote_data_source.dart';
import 'package:flutter_user/features/schedule_screen/data/repository/schedule_repository_impl.dart';
import 'package:flutter_user/features/schedule_screen/data/repository/booking_repository_impl.dart';
import 'package:flutter_user/features/schedule_screen/domain/repository/schedule_repository.dart';
import 'package:flutter_user/features/schedule_screen/domain/repository/booking_repository.dart';
import 'package:flutter_user/features/schedule_screen/domain/usecases/get_schedule_groups_usecase.dart';
import 'package:flutter_user/features/schedule_screen/domain/usecases/book_appointment_usecase.dart';
import 'package:flutter_user/features/schedule_screen/presentation/bloc/schedule_bloc.dart';
import 'package:flutter_user/features/my_appointment_screen/data/datasources/appointment_remote_data_source.dart';
import 'package:flutter_user/features/my_appointment_screen/domain/repository/appointment_repository.dart';
import 'package:flutter_user/features/my_appointment_screen/domain/usecases/get_my_appointments_usecase.dart';
import 'package:flutter_user/features/my_appointment_screen/presentation/bloc/appointment_bloc.dart';
import 'package:flutter_user/firebase_options.dart';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_user/core/network/network_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //----------------------- External  -----------------------
   sl.registerLazySingleton(() => FirebaseFirestore.instance);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  /* ----------------------------------------------------- */
  /*
 * Authentication
 */
  /* ----------------------------------------------------- */
  // BLOC
  sl.registerFactory(
    () => AuthBloc(loginUserUseCase: sl(), signUpUserUseCase: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUserUseCase(userRepository: sl()));
  sl.registerLazySingleton(() => SignUpUserUseCase(userRepository: sl()));

  // repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(networkInfo: sl(), authRemoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  /* ----------------------------------------------------- */
  /*
 * avaliable_doctors_
 */
  /* ----------------------------------------------------- */
  // BLOC
  sl.registerFactory(
    () => AvailableDoctorsScreenBloc(getAvailableDoctorsUsecase: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAvailableDoctorsUsecase(repository: sl()));

  // repository
  sl.registerLazySingleton<AvailableDoctorsRepository>(
    () => AvailableDoctorsRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AvailableDoctorsRemoteDataSource>(
    () => AvailableDoctorsRemoteDataSourceImpl(client: sl()),
  );

  /* ----------------------------------------------------- */
  /*
 * Schedule (Book Appointment)
 */
  /* ----------------------------------------------------- */
  
  // Data Sources
  sl.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(client: sl()),
  );

  // Booking Data Sources
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(client: sl()),
  );

  // Repository
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Booking Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetScheduleGroupsUseCase(repository: sl()));
  sl.registerLazySingleton(() => BookAppointmentUseCase(repository: sl()));

  // BLOC
  sl.registerFactory(
    () => ScheduleBloc(
      getScheduleGroupsUseCase: sl(),
      bookAppointmentUseCase: sl(),
    ),
  );

  /* ----------------------------------------------------- */
  /*
   * My Appointments
   */
  /* ----------------------------------------------------- */
  
  // Data Sources
  sl.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(client: sl()),
  );

  // Repository
  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMyAppointmentsUseCase(repository: sl()));
  sl.registerLazySingleton(() => CancelAppointmentUseCase(repository: sl()));
  // BLOC
  sl.registerFactory(
    () => AppointmentBloc(
      getMyAppointmentsUseCase: sl(),
      cancelAppointmentUseCase: sl(),
    ),
  );
}
