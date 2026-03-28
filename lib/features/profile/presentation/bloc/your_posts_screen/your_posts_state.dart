import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart';

part 'your_posts_state.freezed.dart';

enum YourPostsStatus { initial, loading, loaded, error }

@freezed
abstract class YourPostsState with _$YourPostsState {
  const factory YourPostsState({
    @Default(YourPostsStatus.initial) YourPostsStatus status,
    @Default([]) List<PostEntity> posts,
    @Default([]) List<PostEntity> filtered,
    String? errorMessage,
    String? nextCursor,
    @Default('') String searchQuery,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isSubmittingPost,
  }) = _YourPostsState;
}
