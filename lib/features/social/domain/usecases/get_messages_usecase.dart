import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/chat_repository.dart';

class GetMessagesUsecase
    implements UseCase<List<MessageEntity>, GetMessagesParams> {
  GetMessagesUsecase({required ChatRepository repository})
      : _repository = repository;

  final ChatRepository _repository;

  @override
  Future<Either<Failure, List<MessageEntity>>> call(
    GetMessagesParams params,
  ) => params.isGroup
      ? _repository.getGroupMessages(guid: params.receiverId)
      : _repository.getMessages(uid: params.receiverId);
}

class GetMessagesParams extends Equatable {
  final String receiverId;
  final bool isGroup;

  const GetMessagesParams({required this.receiverId, this.isGroup = false});

  @override
  List<Object?> get props => [receiverId, isGroup];
}
