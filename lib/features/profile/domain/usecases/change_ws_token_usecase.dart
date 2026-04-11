import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/settings_repository.dart';

class ChangeWsTokenUsecase implements UseCase<void, String> {
  ChangeWsTokenUsecase({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository;
  final SettingsRepository _settingsRepository;

  @override
  Future<Either<Failure, void>> call(String newToken) {
    return _settingsRepository.changeWsToken(newToken);
  }
}
