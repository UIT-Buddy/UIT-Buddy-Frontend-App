import 'package:uit_buddy_mobile/features/deadline/domain/entities/deadline_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'deadline_state.freezed.dart';

enum DeadlineStateStatus { initial, loading, loaded, error }

@freezed
abstract class DeadlineState with _$DeadlineState {
  const factory DeadlineState({
    @Default(DeadlineStateStatus.initial) DeadlineStateStatus status,
    DeadlineEntity? deadlineDetail,
    DeadlineDataEntity? deadlineData,
    String? errorMessage,
  }) = _DeadlineState;
}
