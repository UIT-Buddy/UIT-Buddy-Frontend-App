import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/chat_repository.dart';

class SendTextMessageUsecase
    implements UseCase<MessageEntity, SendTextMessageParams> {
  SendTextMessageUsecase({required ChatRepository repository})
    : _repository = repository;

  final ChatRepository _repository;

  @override
  Future<Either<Failure, MessageEntity>> call(SendTextMessageParams params) =>
      _repository.sendTextMessage(
        receiverId: params.receiverId,
        isGroup: params.isGroup,
        text: params.text,
      );
}

class SendTextMessageParams extends Equatable {
  final String receiverId;
  final bool isGroup;
  final String text;

  const SendTextMessageParams({
    required this.receiverId,
    required this.isGroup,
    required this.text,
  });

  @override
  List<Object?> get props => [receiverId, isGroup, text];
}
