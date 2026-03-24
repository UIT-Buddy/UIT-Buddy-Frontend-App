import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/conversation_repository.dart';

class GetConversationsUsecase
    implements UseCase<List<ConversationEntity>, NoParams> {
  GetConversationsUsecase({required ConversationRepository repository})
      : _repository = repository;

  final ConversationRepository _repository;

  @override
  Future<Either<Failure, List<ConversationEntity>>> call(NoParams params) =>
      _repository.getConversations();
}
