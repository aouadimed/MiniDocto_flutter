import 'package:dartz/dartz.dart';
import 'package:flutter_user/core/errors/failures.dart';
import 'package:flutter_user/features/authentication/data/models/user_model.dart';

abstract class UserRepository {
  Future<Either<Failure, UserModel>> loginUser({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> signUpUser({
    required String name,

    required String email,

    required String password,
  });
}
