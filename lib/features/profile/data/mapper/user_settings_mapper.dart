import 'package:uit_buddy_mobile/features/profile/data/models/user_settings_model.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/user_settings_entity.dart';

extension UserSettingsModelMapper on UserSettingsModel {
  UserSettingsEntity toEntity() {
    return UserSettingsEntity(
      enableNotification: enableNotification,
      enableScheduleReminder: enableScheduleReminder,
    );
  }
}

extension UserSettingsEntityMapper on UserSettingsEntity {
  UserSettingsModel toModel() {
    return UserSettingsModel(
      enableNotification: enableNotification,
      enableScheduleReminder: enableScheduleReminder,
    );
  }
}
