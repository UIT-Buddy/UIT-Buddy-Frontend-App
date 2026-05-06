import 'package:equatable/equatable.dart';

enum TimeUnit { minute, hour, day, week }

class IncomingDeadlineEntity extends Equatable {
  const IncomingDeadlineEntity({
    required this.id,
    required this.deadlineName,
    required this.remainingTime,
    required this.dueDate,
  });

  final String id;
  final String deadlineName;
  final RemainingTimeEntity remainingTime;
  final DateTime dueDate;

  @override
  List<Object?> get props => [id, deadlineName, remainingTime, dueDate];
}

class RemainingTimeEntity extends Equatable {
  const RemainingTimeEntity({required this.unit, required this.unitName});

  final int unit;
  final TimeUnit unitName;

  @override
  List<Object?> get props => [unit, unitName];
}
