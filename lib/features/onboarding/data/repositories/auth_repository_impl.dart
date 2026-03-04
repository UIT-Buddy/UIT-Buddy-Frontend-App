import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/datasources/auth_remote_datasource.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/mapper/signup_complete_mapper.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/mapper/signup_init_mapper.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_complete_entity.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_init_entity.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDatasource authRemoteDatasource})
    : _authRemoteDatasource = authRemoteDatasource;

  final AuthRemoteDatasource _authRemoteDatasource;

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
}
