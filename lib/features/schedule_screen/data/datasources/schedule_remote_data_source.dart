import 'package:flutter_user/core/constants/constants.dart';
import 'package:flutter_user/core/errors/exceptions.dart';
import 'package:flutter_user/core/util/shared_pref_module.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';
import '../models/schedule_group_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<ScheduleGroupsResponse> getScheduleGroups({
    required int page,
    required int pageSize,
    required String doctorId,
  });
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final https.Client client;

  ScheduleRemoteDataSourceImpl({required this.client});

  @override
  Future<ScheduleGroupsResponse> getScheduleGroups({
    required int page,
    required int pageSize,
    required String doctorId,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      final uri = Uri.parse('$url$scheduleGroupsBaseUrl/$doctorId/schedule-groups')
          .replace(queryParameters: queryParameters);
      
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
        final jsonData = json.decode(response.body);
        return ScheduleGroupsResponse.fromJson(jsonData);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
