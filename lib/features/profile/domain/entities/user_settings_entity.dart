import 'package:equatable/equatable.dart';

class UserSettingsEntity extends Equatable {
  const UserSettingsEntity({
    required this.enableNotification,
    required this.enableScheduleReminder,
  });

  final bool enableNotification;
  final bool enableScheduleReminder;

  UserSettingsEntity copyWith({
    bool? enableNotification,
    bool? enableScheduleReminder,
  }) {
    return UserSettingsEntity(
      enableNotification: enableNotification ?? this.enableNotification,
      enableScheduleReminder:
          enableScheduleReminder ?? this.enableScheduleReminder,
    );
  }

  @override
  List<Object?> get props => [enableNotification, enableScheduleReminder];
}
