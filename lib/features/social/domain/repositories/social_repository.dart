import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';

abstract interface class SocialRepository {
  Future<Either<Failure, PagedResult<PostEntity>>> getPosts({
    String? cursor,
    int limit = 10,
  });

  Future<Either<Failure, PostEntity>> createPost({
    required String title,
    String? content,
    List<XFile> images = const [],
    List<XFile> videos = const [],
  });
}
