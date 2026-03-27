import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/conversation_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  ConversationRepositoryImpl({
    required ConversationDatasourceInterface datasource,
  }) : _datasource = datasource;

  final ConversationDatasourceInterface _datasource;

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations({
    int limit = 50,
  }) async {
    try {
      final conversations = await _datasource.getConversations(limit: limit);
      return Right(conversations);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  void reset() {
    _datasource.reset();
  }
}
