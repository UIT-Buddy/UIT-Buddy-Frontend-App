import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/chat_repository.dart';

class DeleteMessageUsecase implements UseCase<void, DeleteMessageParams> {
  DeleteMessageUsecase({required ChatRepository repository})
    : _repository = repository;

  final ChatRepository _repository;

  @override
  Future<Either<Failure, void>> call(DeleteMessageParams params) =>
      _repository.deleteMessage(messageId: params.messageId);
}

class DeleteMessageParams extends Equatable {
  final String messageId;

  const DeleteMessageParams({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}
