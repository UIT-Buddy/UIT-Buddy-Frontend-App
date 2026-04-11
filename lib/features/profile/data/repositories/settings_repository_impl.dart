import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/token/token_store.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/change_ws_token_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/delete_account_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required ChangeWsTokenDatasourceInterface changeWsTokenDatasource,
    required DeleteAccountDatasourceInterface deleteAccountDatasource,
    required TokenStore tokenStore,
  }) : _changeWsTokenDatasource = changeWsTokenDatasource,
       _deleteAccountDatasource = deleteAccountDatasource,
       _tokenStore = tokenStore;

  final ChangeWsTokenDatasourceInterface _changeWsTokenDatasource;
  final DeleteAccountDatasourceInterface _deleteAccountDatasource;
  final TokenStore _tokenStore;

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
