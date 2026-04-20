import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/user_settings_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/user_settings_model.dart';

class UserSettingsDatasourceImpl implements UserSettingsDatasourceInterface {
  UserSettingsDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<Either<Failure, UserSettingsModel>> getUserSettings() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/user/settings',
      );
      final body = response.data;
      if (body == null) {
        return left(
          Failure('Cannot fetch user settings: empty response body.'),
        );
      }

      return right(UserSettingsModel.fromJson(body));
    } on Exception catch (e) {
      return left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, UserSettingsModel>> updateUserSettings({
    required bool enableNotification,
    required bool enableScheduleReminder,
  }) async {
    try {
      final payload = {
        'enableNotification': enableNotification,
        'enableScheduleReminder': enableScheduleReminder,
      };

      final response = await _dio.patch<Map<String, dynamic>>(
        '/api/user/settings',
        data: payload,
      );

      final body = response.data;
      if (body == null) {
        return right(
          UserSettingsModel(
            enableNotification: enableNotification,
            enableScheduleReminder: enableScheduleReminder,
          ),
        );
      }

      return right(UserSettingsModel.fromJson(body));
    } on Exception catch (e) {
      return left(Failure.fromException(e));
    }
  }
}
