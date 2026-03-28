import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';

abstract interface class ConversationRepository {
  Future<Either<Failure, List<ConversationEntity>>> getConversations({
    int limit = 50,
  });

  void reset();
}
