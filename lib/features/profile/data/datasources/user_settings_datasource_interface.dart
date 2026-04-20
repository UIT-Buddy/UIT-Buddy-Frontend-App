import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/user_settings_model.dart';

abstract interface class UserSettingsDatasourceInterface {
  Future<Either<Failure, UserSettingsModel>> getUserSettings();

  Future<Either<Failure, UserSettingsModel>> updateUserSettings({
    required bool enableNotification,
    required bool enableScheduleReminder,
  });
}
