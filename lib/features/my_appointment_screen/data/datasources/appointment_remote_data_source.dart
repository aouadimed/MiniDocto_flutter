import 'dart:convert';
import 'package:flutter_user/core/constants/constants.dart';
import 'package:flutter_user/core/util/shared_pref_module.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../models/appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<AppointmentsResponseModel> getMyAppointments({
    required int page,
    int pageSize = 10,
  });

  Future<void> cancelAppointment({required String appointmentId});
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final http.Client client;

  AppointmentRemoteDataSourceImpl({required this.client});

  @override
  Future<AppointmentsResponseModel> getMyAppointments({
    required int page,
    int pageSize = 10,
  }) async {
    try {
      final uri = Uri.parse('${url}appointments/me').replace(
        queryParameters: {
          'page': page.toString(),
          'pageSize': pageSize.toString(),
        },
      );

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await TokenManager.getValidAccessToken()}',
      };

      final response = await client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        return AppointmentsResponseModel.fromJson(jsonResponse);
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<void> cancelAppointment({required String appointmentId}) async {
    try {
      final uri = Uri.parse('${url}appointments/$appointmentId');

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await TokenManager.getValidAccessToken()}',
      };

      final response = await client.delete(uri, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Success - appointment cancelled
        return;
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException();
    }
  }
}
