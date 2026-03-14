import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/social_repository.dart';

class ToggleLikeUsecase implements UseCase<Unit, ToggleLikeParams> {
  ToggleLikeUsecase({required SocialRepository repository})
    : _repository = repository;

  final SocialRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ToggleLikeParams params) =>
      _repository.toggleLike(params.postId);
}

class ToggleLikeParams extends Equatable {
  final String postId;

  const ToggleLikeParams({required this.postId});

  @override
  List<Object?> get props => [postId];
}
