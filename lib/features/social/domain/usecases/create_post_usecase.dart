import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/social_repository.dart';

class CreatePostUsecase implements UseCase<Unit, CreatePostParams> {
  CreatePostUsecase({required SocialRepository repository})
    : _repository = repository;

  final SocialRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(CreatePostParams params) =>
      _repository.createPost(
        title: params.title,
        content: params.content,
        images: params.images,
        videos: params.videos,
      );
}

class CreatePostParams extends Equatable {
  final String title;
  final String? content;
  final List<XFile> images;
  final List<XFile> videos;

  const CreatePostParams({
    required this.title,
    this.content,
    this.images = const [],
    this.videos = const [],
  });

  @override
  List<Object?> get props => [title, content];
}
