import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/call_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/call_repository.dart';

class InitiateCallUsecase implements UseCase<CallEntity, InitiateCallParams> {
  InitiateCallUsecase({required CallRepository repository})
    : _repository = repository;

  final CallRepository _repository;

  @override
  Future<Either<Failure, CallEntity>> call(InitiateCallParams params) {
    return _repository.initiateCall(
      receiverId: params.receiverId,
      isGroup: params.isGroup,
    );
  }
}

class InitiateCallParams extends Equatable {
  final String receiverId;
  final bool isGroup;

  const InitiateCallParams({required this.receiverId, this.isGroup = false});

  @override
  List<Object?> get props => [receiverId, isGroup];
}
