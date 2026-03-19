import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/token/token_store.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/delete_account_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required DeleteAccountDatasource deleteAccountDatasource,
    required TokenStore tokenStore,
  }) : _deleteAccountDatasource = deleteAccountDatasource,
       _tokenStore = tokenStore;

  final DeleteAccountDatasource _deleteAccountDatasource;
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
}
