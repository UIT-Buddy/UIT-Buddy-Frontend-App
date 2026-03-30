import 'package:equatable/equatable.dart';

abstract class AddDeadlineEvent extends Equatable {
  const AddDeadlineEvent();

  @override
  List<Object?> get props => [];
}

class AddDeadlineStarted extends AddDeadlineEvent {
  const AddDeadlineStarted();
}

class AddDeadlineSearchClassCodesRequested extends AddDeadlineEvent {
  const AddDeadlineSearchClassCodesRequested(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class AddDeadlineCreateRequested extends AddDeadlineEvent {
  const AddDeadlineCreateRequested({
    required this.name,
    this.classCode,
    required this.deadline,
  });

  final String name;
  final String? classCode;
  final DateTime deadline;

  @override
  List<Object?> get props => [name, classCode, deadline];
}
