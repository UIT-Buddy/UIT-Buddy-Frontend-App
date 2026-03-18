import 'package:equatable/equatable.dart';

abstract class ContactPickerEvent extends Equatable {
  const ContactPickerEvent();

  @override
  List<Object?> get props => [];
}

class ContactPickerStarted extends ContactPickerEvent {
  const ContactPickerStarted({this.excludeIds = const []});

  final List<String> excludeIds;

  @override
  List<Object?> get props => [excludeIds];
}

class ContactPickerSearchChanged extends ContactPickerEvent {
  const ContactPickerSearchChanged({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

class ContactPickerToggled extends ContactPickerEvent {
  const ContactPickerToggled({required this.memberId});

  final String memberId;

  @override
  List<Object?> get props => [memberId];
}
