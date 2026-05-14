import 'package:equatable/equatable.dart';

abstract class DeadlineModeEvent extends Equatable {
  const DeadlineModeEvent();

  @override
  List<Object?> get props => [];
}

class DeadlineModeStarted extends DeadlineModeEvent {
  const DeadlineModeStarted();
}

class DeadlineModeEntitySelected extends DeadlineModeEvent {
  const DeadlineModeEntitySelected(this.day);
  final int day;

  @override
  List<Object?> get props => [day];
}

class DeadlineModeNextMonthSelected extends DeadlineModeEvent {
  const DeadlineModeNextMonthSelected();
}

class DeadlineModePreviousMonthSelected extends DeadlineModeEvent {
  const DeadlineModePreviousMonthSelected();
}
