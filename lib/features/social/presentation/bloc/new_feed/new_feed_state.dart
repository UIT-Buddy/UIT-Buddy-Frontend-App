import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';

part 'new_feed_state.freezed.dart';

enum NewFeedStatus { initial, loading, loaded, error }

enum NewFeedTab { feed, message }

@freezed
abstract class NewFeedState with _$NewFeedState {
  const factory NewFeedState({
    @Default(NewFeedStatus.initial) NewFeedStatus status,
    @Default([]) List<PostEntity> posts,
    @Default(NewFeedTab.feed) NewFeedTab selectedTab,
    String? errorMessage,
    String? nextCursor,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
  }) = _NewFeedState;
}
