import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/post_repository.dart';

class GetPostDetailUsecase implements UseCase<PostEntity, GetPostDetailParams> {
  GetPostDetailUsecase({required PostRepository repository})
    : _repository = repository;

  final PostRepository _repository;

  @override
  Future<Either<Failure, PostEntity>> call(GetPostDetailParams params) =>
      _repository.getPostDetail(params.postId);
}

class GetPostDetailParams extends Equatable {
  final String postId;

  const GetPostDetailParams({required this.postId});

  @override
  List<Object?> get props => [postId];
}
