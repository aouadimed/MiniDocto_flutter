import 'package:flutter_user/core/errors/failures.dart';
import 'package:flutter_user/core/usecases/usecase.dart';
import 'package:flutter_user/features/authentication/data/models/user_model.dart';
import 'package:flutter_user/features/authentication/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SignUpUserUseCase extends UseCase<UserModel, SignUpUserParams> {
  final UserRepository userRepository;

  const SignUpUserUseCase({required this.userRepository});

  @override
  Future<Either<Failure, UserModel>> call(SignUpUserParams params) async {
    return await userRepository.signUpUser(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpUserParams extends Equatable {
  final String name;

  final String email;

  final String password;

  const SignUpUserParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}
