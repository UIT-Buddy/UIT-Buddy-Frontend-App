import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/user_settings_entity.dart';

abstract interface class SettingsRepository {
  Future<Either<Failure, UserSettingsEntity>> getUserSettings();

  Future<Either<Failure, UserSettingsEntity>> updateUserSettings({
    required bool enableNotification,
    required bool enableScheduleReminder,
  });

  Future<Either<Failure, void>> deleteAccount();

  Future<Either<Failure, void>> changeWsToken(String newToken);
}
