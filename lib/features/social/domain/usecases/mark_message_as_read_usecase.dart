import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/chat_repository.dart';

class MarkMessageAsReadUsecase
    implements UseCase<void, MarkMessageAsReadParams> {
  MarkMessageAsReadUsecase({required ChatRepository repository})
    : _repository = repository;

  final ChatRepository _repository;

  @override
  Future<Either<Failure, void>> call(MarkMessageAsReadParams params) =>
      _repository.markAsRead(message: params.message);
}

class MarkMessageAsReadParams extends Equatable {
  const MarkMessageAsReadParams({required this.message});

  final MessageEntity message;

  @override
  List<Object?> get props => [message];
}
