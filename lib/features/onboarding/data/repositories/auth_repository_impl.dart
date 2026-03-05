import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/token/token_store.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/datasources/auth_remote_datasource.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/mapper/signup_complete_mapper.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/mapper/signup_init_mapper.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_complete_entity.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_init_entity.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDatasource authRemoteDatasource,
    required TokenStore tokenStore,
  }) : _authRemoteDatasource = authRemoteDatasource,
       _tokenStore = tokenStore;

  final AuthRemoteDatasource _authRemoteDatasource;
  final TokenStore _tokenStore;

  @override
  Future<Either<Failure, SignUpInitEntity>> signUpInit({
    required String wstoken,
  }) async {
    try {
      final response = await _authRemoteDatasource.signUpInit(wstoken: wstoken);

      if (response.data == null) {
        return Left(Failure(response.message));
      }

      return Right(response.data!.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, SignUpCompleteEntity>> signUpComplete({
    required String signupToken,
    required String mssv,
    required String password,
    required String confirmPassword,
    String fcmToken = '',
  }) async {
    try {
      final response = await _authRemoteDatasource.signUpComplete(
        signupToken: signupToken,
        mssv: mssv,
        password: password,
        confirmPassword: confirmPassword,
        fcmToken: fcmToken,
      );

      if (response.data == null) {
        return Left(Failure(response.message));
      }

      return Right(response.data!.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, SignUpCompleteEntity>> signIn({
    required String mssv,
    required String password,
    bool rememberMe = false,
    String fcmToken = '',
  }) async {
    try {
      final response = await _authRemoteDatasource.signIn(
        mssv: mssv,
        password: password,
        rememberMe: rememberMe,
        fcmToken: fcmToken,
      );

      if (response.data == null) {
        return Left(Failure(response.message));
      }

      final entity = response.data!.toEntity();
      await _tokenStore.saveAccessToken(entity.accessToken);
      await _tokenStore.saveRefreshToken(
        entity.refreshToken,
        rememberMe: rememberMe,
      );

      return Right(entity);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> forgetPassword({required String mssv}) async {
    try {
      await _authRemoteDatasource.forgetPassword(mssv: mssv);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String mssv,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await _authRemoteDatasource.resetPassword(
        mssv: mssv,
        otpCode: otpCode,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
