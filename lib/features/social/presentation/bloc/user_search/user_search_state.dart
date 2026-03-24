import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';

part 'user_search_state.freezed.dart';

enum UserSearchStatus { initial, loading, loaded, error }

@freezed
abstract class UserSearchState with _$UserSearchState {
  const factory UserSearchState({
    @Default(UserSearchStatus.initial) UserSearchStatus status,
    @Default([]) List<ConversationEntity> users,
    @Default('') String query,
    String? errorMessage,
  }) = _UserSearchState;
}
