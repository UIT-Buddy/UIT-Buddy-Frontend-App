import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/chat_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({required ChatDatasourceInterface datasource})
    : _datasource = datasource;

  final ChatDatasourceInterface _datasource;

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String uid,
    int limit = 30,
  }) async {
    try {
      final messages = await _datasource.getMessages(uid: uid, limit: limit);
      return Right(messages);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getGroupMessages({
    required String guid,
    int limit = 30,
  }) async {
    try {
      final messages = await _datasource.getGroupMessages(
        guid: guid,
        limit: limit,
      );
      return Right(messages);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
