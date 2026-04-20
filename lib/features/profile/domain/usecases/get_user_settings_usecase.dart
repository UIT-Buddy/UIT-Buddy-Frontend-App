import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/user_settings_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/settings_repository.dart';

class GetUserSettingsUsecase implements UseCase<UserSettingsEntity, NoParams> {
  GetUserSettingsUsecase({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository;

  final SettingsRepository _settingsRepository;

  @override
  Future<Either<Failure, UserSettingsEntity>> call(NoParams params) {
    return _settingsRepository.getUserSettings();
  }
}
