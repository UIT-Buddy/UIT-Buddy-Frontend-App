import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_deadline_state.freezed.dart';

enum AddDeadlineStatus { initial, loading, created, error }

@freezed
abstract class AddDeadlineState with _$AddDeadlineState {
  const factory AddDeadlineState({
    @Default(AddDeadlineStatus.initial) AddDeadlineStatus status,
    @Default(<String>[]) List<String> allClassCodes,
    @Default(<String>[]) List<String> suggestions,
    String? errorMessage,
  }) = _AddDeadlineState;
}
