import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';

abstract interface class PostRepository {
  Future<Either<Failure, PagedResult<PostEntity>>> getPosts({
    String? cursor,
    int limit = 10,
  });

  Future<Either<Failure, PagedResult<PostEntity>>> searchPosts({
    required String keyword,
    int page = 1,
    int limit = 10,
    String? sortBy,
    String? sortType,
  });

  Future<Either<Failure, Unit>> createPost({
    required String title,
    String? content,
    List<XFile> images = const [],
    List<XFile> videos = const [],
  });

  Future<Either<Failure, Unit>> deletePost(String postId);

  Future<Either<Failure, PostEntity>> getPostDetail(String postId);

  Future<Either<Failure, Unit>> updatePost({
    required String postId,
    required String title,
    String? content,
  });
}
