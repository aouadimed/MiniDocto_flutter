import 'package:dartz/dartz.dart';
import 'package:flutter_user/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  const UseCase();
  Future<Either<Failure, Type>> call(Params params);
}
