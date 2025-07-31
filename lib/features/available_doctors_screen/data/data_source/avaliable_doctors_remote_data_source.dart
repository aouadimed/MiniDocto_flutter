import 'package:flutter_user/core/constants/constants.dart';
import 'package:flutter_user/core/errors/exceptions.dart';
import 'package:flutter_user/core/util/shared_pref_module.dart';
import 'package:flutter_user/features/available_doctors_screen/data/models/available_doctor_model.dart';
import 'package:http/http.dart' as https;

abstract class AvailableDoctorsRemoteDataSource {
  Future<AvailableDoctor> getAvailableDoctors(int page);
}

class AvailableDoctorsRemoteDataSourceImpl
    implements AvailableDoctorsRemoteDataSource {
  final https.Client client;

  AvailableDoctorsRemoteDataSourceImpl({required this.client});

  @override
  Future<AvailableDoctor> getAvailableDoctors(int page) async {
    try {
      final queryParameters = {'page': page.toString()};
      final uri = Uri.parse('$url$availableDoctorsBaseUrl').replace(queryParameters: queryParameters);
      final response = await client
          .get(
            uri,
            headers: {
              "Content-type": "application/json",
              "Authorization": "Bearer ${await TokenManager.getValidAccessToken()}",
            },
          )
          .catchError((e) {
            throw ServerException();
          });
      if (response.statusCode == 200) {
        return availableDoctorFromJson(response.body);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
