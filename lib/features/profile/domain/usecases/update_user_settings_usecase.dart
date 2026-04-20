import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/user_settings_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/settings_repository.dart';

class UpdateUserSettingsUsecase
    implements UseCase<UserSettingsEntity, UpdateUserSettingsParams> {
  UpdateUserSettingsUsecase({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository;

  final SettingsRepository _settingsRepository;

  @override
  Future<Either<Failure, UserSettingsEntity>> call(
    UpdateUserSettingsParams params,
  ) {
    return _settingsRepository.updateUserSettings(
      enableNotification: params.enableNotification,
      enableScheduleReminder: params.enableScheduleReminder,
    );
  }
}

class UpdateUserSettingsParams extends Equatable {
  const UpdateUserSettingsParams({
    required this.enableNotification,
    required this.enableScheduleReminder,
  });

  final bool enableNotification;
  final bool enableScheduleReminder;

  @override
  List<Object?> get props => [enableNotification, enableScheduleReminder];
}
