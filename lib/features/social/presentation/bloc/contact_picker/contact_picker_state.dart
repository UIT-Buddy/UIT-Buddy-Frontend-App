import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/chat_member_entity.dart';

part 'contact_picker_state.freezed.dart';

enum ContactPickerStatus { initial, loaded }

@freezed
abstract class ContactPickerState with _$ContactPickerState {
  const factory ContactPickerState({
    @Default(ContactPickerStatus.initial) ContactPickerStatus status,
    @Default([]) List<ChatMemberEntity> allContacts,
    @Default([]) List<ChatMemberEntity> filteredContacts,
    @Default(<String>{}) Set<String> selectedIds,
    @Default('') String query,
  }) = _ContactPickerState;
}
