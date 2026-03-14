import 'package:image_picker/image_picker.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/social/data/models/comment_model.dart';
import 'package:uit_buddy_mobile/features/social/data/models/post_model.dart';

abstract interface class SocialDatasourceInterface {
  // ─── Posts ─────────────────────────────────────────────────────────────────

  Future<PagedResult<PostModel>> getPosts({String? cursor, int limit = 10});

  Future<PostModel> createPost({
    required String title,
    String? content,
    List<XFile> images = const [],
    List<XFile> videos = const [],
  });

  Future<void> deletePost(String postId);

  Future<void> toggleLike(String postId);

  Future<PostModel> getPostDetail(String postId);

  // ─── Comments ──────────────────────────────────────────────────────────────

  Future<PagedResult<CommentModel>> getPostComments({
    required String postId,
    String? cursor,
    int limit = 10,
  });

  Future<void> createComment({
    required String postId,
    required String content,
  });

  Future<void> replyToComment({
    required String commentId,
    required String content,
  });

  Future<void> updateComment({
    required String commentId,
    required String content,
  });

  Future<PagedResult<CommentModel>> getCommentReplies({
    required String commentId,
    String? cursor,
    int limit = 5,
  });

  Future<void> deleteComment(String commentId);

  Future<void> toggleCommentLike(String commentId);
}
