import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/chat_repository.dart';

class EditTextMessageUsecase
    implements UseCase<MessageEntity, EditTextMessageParams> {
  EditTextMessageUsecase({required ChatRepository repository})
    : _repository = repository;

  final ChatRepository _repository;

  @override
  Future<Either<Failure, MessageEntity>> call(EditTextMessageParams params) =>
      _repository.editTextMessage(
        messageId: params.messageId,
        text: params.text,
        receiverId: params.receiverId,
        isGroup: params.isGroup,
      );
}

class EditTextMessageParams extends Equatable {
  final String messageId;
  final String text;
  final String receiverId;
  final bool isGroup;

  const EditTextMessageParams({
    required this.messageId,
    required this.text,
    required this.receiverId,
    required this.isGroup,
  });

  @override
  List<Object?> get props => [messageId, text, receiverId, isGroup];
}
