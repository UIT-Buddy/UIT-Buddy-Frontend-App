import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/data/mock/mock_chat_settings.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/contact_picker/contact_picker_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/contact_picker/contact_picker_state.dart';

class ContactPickerBloc extends Bloc<ContactPickerEvent, ContactPickerState> {
  ContactPickerBloc() : super(const ContactPickerState()) {
    on<ContactPickerStarted>(_onStarted);
    on<ContactPickerSearchChanged>(_onSearchChanged);
    on<ContactPickerToggled>(_onToggled);
  }

  void _onStarted(
    ContactPickerStarted event,
    Emitter<ContactPickerState> emit,
  ) {
    final all = getMockFriends()
        .where((c) => !event.excludeIds.contains(c.id))
        .toList();

    emit(
      state.copyWith(
        status: ContactPickerStatus.loaded,
        allContacts: all,
        filteredContacts: all,
      ),
    );
  }

  void _onSearchChanged(
    ContactPickerSearchChanged event,
    Emitter<ContactPickerState> emit,
  ) {
    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? state.allContacts
        : state.allContacts
              .where((c) => c.name.toLowerCase().contains(query))
              .toList();

    emit(state.copyWith(filteredContacts: filtered, query: event.query));
  }

  void _onToggled(
    ContactPickerToggled event,
    Emitter<ContactPickerState> emit,
  ) {
    final updated = Set<String>.from(state.selectedIds);
    if (updated.contains(event.memberId)) {
      updated.remove(event.memberId);
    } else {
      updated.add(event.memberId);
    }
    emit(state.copyWith(selectedIds: updated));
  }
}
