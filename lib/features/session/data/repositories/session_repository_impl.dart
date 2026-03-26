import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/session/data/datasources/session_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/session/data/mapper/user_mapper.dart';
import 'package:uit_buddy_mobile/features/session/domain/entities/user_entity.dart';
import 'package:uit_buddy_mobile/features/session/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl({required SessionDatasourceInterface datasource})
    : _datasource = datasource;

  final SessionDatasourceInterface _datasource;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final response = await _datasource.getCurrentUser();
      return Right(response.data!.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
