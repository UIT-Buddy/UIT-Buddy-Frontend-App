import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/token/token_store.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/change_ws_token_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/delete_account_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/user_settings_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/mapper/user_settings_mapper.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/user_settings_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required UserSettingsDatasourceInterface userSettingsDatasource,
    required ChangeWsTokenDatasourceInterface changeWsTokenDatasource,
    required DeleteAccountDatasourceInterface deleteAccountDatasource,
    required TokenStore tokenStore,
  }) : _userSettingsDatasource = userSettingsDatasource,
       _changeWsTokenDatasource = changeWsTokenDatasource,
       _deleteAccountDatasource = deleteAccountDatasource,
       _tokenStore = tokenStore;

  final UserSettingsDatasourceInterface _userSettingsDatasource;
  final ChangeWsTokenDatasourceInterface _changeWsTokenDatasource;
  final DeleteAccountDatasourceInterface _deleteAccountDatasource;
  final TokenStore _tokenStore;

  @override
  Future<Either<Failure, UserSettingsEntity>> getUserSettings() async {
    final result = await _userSettingsDatasource.getUserSettings();
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Either<Failure, UserSettingsEntity>> updateUserSettings({
    required bool enableNotification,
    required bool enableScheduleReminder,
  }) async {
    final result = await _userSettingsDatasource.updateUserSettings(
      enableNotification: enableNotification,
      enableScheduleReminder: enableScheduleReminder,
    );

    return result.map((model) => model.toEntity());
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    final result = await _deleteAccountDatasource.deleteAccount();

    // Clear local tokens regardless of success/error if the account is effectively deactivated
    // Wait, let's only clear if successful
    return result.bind((_) {
      _tokenStore.deleteAccessToken();
      _tokenStore.deleteRefreshToken();
      return right(null);
    });
  }

  @override
  Future<Either<Failure, void>> changeWsToken(String newToken) async {
    final result = await _changeWsTokenDatasource.changeWsToken(newToken);

    return result.bind((_) {
      return right(null);
    });
  }
}
