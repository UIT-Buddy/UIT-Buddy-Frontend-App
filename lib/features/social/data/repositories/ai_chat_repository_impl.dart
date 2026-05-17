import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/ai_chat_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/ai_chat_repository.dart';

class AIChatRepositoryImpl implements AIChatRepository {
  AIChatRepositoryImpl({required AIChatDatasourceInterface datasource})
    : _datasource = datasource;

  final AIChatDatasourceInterface _datasource;

  @override
  Future<Either<Failure, String>> sendMessage(String message) async {
    try {
      final response = await _datasource.sendMessage(message);
      return Right(response);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
