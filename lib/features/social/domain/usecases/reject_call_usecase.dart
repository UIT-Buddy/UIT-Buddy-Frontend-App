import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/call_repository.dart';

class RejectCallUsecase implements UseCase<void, RejectCallParams> {
  RejectCallUsecase({required CallRepository repository})
    : _repository = repository;

  final CallRepository _repository;

  @override
  Future<Either<Failure, void>> call(RejectCallParams params) {
    return _repository.rejectCall(params.sessionId, busy: params.busy);
  }
}

class RejectCallParams extends Equatable {
  final String sessionId;
  final bool busy;

  const RejectCallParams({required this.sessionId, this.busy = false});

  @override
  List<Object?> get props => [sessionId, busy];
}
