import 'package:equatable/equatable.dart';

abstract class DeadlineEvent extends Equatable {
  const DeadlineEvent();

  @override
  List<Object?> get props => [];
}

class DeadlineStarted extends DeadlineEvent {
  const DeadlineStarted();
}

class DeadlineEntitySelected extends DeadlineEvent {
  const DeadlineEntitySelected(this.day);
  final int day;

  @override
  List<Object?> get props => [day];
}

class DeadlineNextMonthSelected extends DeadlineEvent {
  const DeadlineNextMonthSelected();
}

class DeadlinePreviousMonthSelected extends DeadlineEvent {
  const DeadlinePreviousMonthSelected();
}
