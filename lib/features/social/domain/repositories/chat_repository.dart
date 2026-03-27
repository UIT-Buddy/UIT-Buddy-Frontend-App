import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';

abstract interface class ChatRepository {
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String uid,
    int limit = 30,
  });

  Future<Either<Failure, List<MessageEntity>>> getGroupMessages({
    required String guid,
    int limit = 30,
  });

  Future<Either<Failure, MessageEntity>> sendTextMessage({
    required String receiverId,
    required bool isGroup,
    required String text,
  });
}
