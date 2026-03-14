import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/token/token_store.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/sign_out_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/sign_out_repository.dart';

class SignOutRepositoryImpl implements SignOutRepository {
  SignOutRepositoryImpl({
    required SignOutDatasource signOutDatasource,
    required TokenStore tokenStore,
  })  : _signOutDatasource = signOutDatasource,
        _tokenStore = tokenStore;

  final SignOutDatasource _signOutDatasource;
  final TokenStore _tokenStore;

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final refreshToken = await _tokenStore.getRefreshToken();
      await _signOutDatasource.signOut(refreshToken: refreshToken);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    } finally {
      // Always clear local tokens, even on network failure
      try {
        await _tokenStore.deleteAccessToken();
        await _tokenStore.deleteRefreshToken();
      } on Exception catch (_) {}
    }
  }
}
