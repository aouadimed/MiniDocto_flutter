import 'package:flutter_user/core/constants/constants.dart';
import 'package:flutter_user/core/errors/exceptions.dart';
import 'package:flutter_user/core/util/shared_pref_module.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';
import '../models/booking_request_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingResponseModel> bookAppointment({
    required String doctorId,
    required String slotId,
  });
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final https.Client client;

  BookingRemoteDataSourceImpl({required this.client});

  @override
  Future<BookingResponseModel> bookAppointment({
    required String doctorId,
    required String slotId,
  }) async {
    try {
      final bookingRequest = BookingRequestModel(
        doctorId: doctorId,
        slotId: slotId,
      );

      final response = await client
          .post(
            Uri.parse('${url}appointments/book'),
            headers: {
              "Content-type": "application/json",
              "Authorization":
                  "Bearer ${await TokenManager.getValidAccessToken()}",
            },
            body: json.encode(bookingRequest.toJson()),
          )
          .catchError((e) {
            throw ServerException();
          });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return BookingResponseModel.fromJson(jsonData);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
