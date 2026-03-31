import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/call_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/call_repository.dart';

class AcceptCallUsecase implements UseCase<CallEntity, AcceptCallParams> {
  AcceptCallUsecase({required CallRepository repository})
    : _repository = repository;

  final CallRepository _repository;

  @override
  Future<Either<Failure, CallEntity>> call(AcceptCallParams params) {
    return _repository.acceptCall(params.sessionId);
  }
}

class AcceptCallParams extends Equatable {
  final String sessionId;

  const AcceptCallParams({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}
