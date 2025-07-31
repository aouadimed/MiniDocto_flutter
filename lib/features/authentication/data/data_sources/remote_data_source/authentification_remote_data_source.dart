import 'dart:convert';

import 'package:flutter_user/core/constants/constants.dart';
import 'package:flutter_user/core/errors/exceptions.dart';
import 'package:flutter_user/features/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as https;

abstract class AuthRemoteDataSource {
  Future<UserModel> loginUser({
    required String email,
    required String password,
  });

  Future<UserModel> signUpUser({
    required String name,

    required String email,

    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final https.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      Map<String, dynamic> requestBody = {"email": email, "password": password};
      final response = await client
          .post(
            Uri.parse('$url$loginBaseUrl'),
            body: jsonEncode(requestBody),
            headers: {"Content-Type": "application/json"},
          )
          .catchError((e) => throw ServerException());

      if (response.statusCode == 200) {
        return userModelFromJson(response.body);
      } else if (response.statusCode == 400) {
        throw WrongCredentialException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e.runtimeType == WrongCredentialException) {
        throw WrongCredentialException();
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<UserModel> signUpUser({
    required String name,

    required String email,

    required String password,
  }) async {
    try {
      var uri = Uri.parse('$url$registerBaseUrl');

      Map<String, dynamic> requestBody = {
        "name": name,
        "email": email,
        "password": password,
        "role": "USER",
      };

      final response = await https
          .post(
            uri,
            body: jsonEncode(requestBody),
            headers: {"Content-Type": "application/json"},
          )
          .catchError((e) => throw ServerException());
      final responseBody = response.body;
      if (response.statusCode == 200) {
        return userModelFromJson(responseBody);
      } else if (response.statusCode == 400) {
        throw UserExistException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is UserExistException) {
        throw UserExistException();
      } else {
        throw ServerException();
      }
    }
  }
}
