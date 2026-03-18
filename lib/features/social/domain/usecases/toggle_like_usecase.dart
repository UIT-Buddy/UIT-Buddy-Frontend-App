import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/reaction_repository.dart';

class ToggleLikeUsecase implements UseCase<Unit, ToggleLikeParams> {
  ToggleLikeUsecase({required ReactionRepository repository})
      : _repository = repository;

  final ReactionRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ToggleLikeParams params) =>
      _repository.togglePostLike(params.postId);
}

class ToggleLikeParams extends Equatable {
  final String postId;

  const ToggleLikeParams({required this.postId});

  @override
  List<Object?> get props => [postId];
}
