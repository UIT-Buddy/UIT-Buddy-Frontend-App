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

  Future<Either<Failure, MessageEntity>> editTextMessage({
    required String messageId,
    required String text,
    required String receiverId,
    required bool isGroup,
  });

  Future<Either<Failure, void>> deleteMessage({required String messageId});

  Future<Either<Failure, void>> markAsRead({required MessageEntity message});

  void reset();
}
