import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/call_repository.dart';

class EndCallUsecase implements UseCase<void, EndCallParams> {
  EndCallUsecase({required CallRepository repository})
    : _repository = repository;

  final CallRepository _repository;

  @override
  Future<Either<Failure, void>> call(EndCallParams params) {
    return _repository.endCall(params.sessionId);
  }
}

class EndCallParams extends Equatable {
  final String sessionId;

  const EndCallParams({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}
