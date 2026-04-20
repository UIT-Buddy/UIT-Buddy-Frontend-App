class UserSettingsModel {
  const UserSettingsModel({
    required this.enableNotification,
    required this.enableScheduleReminder,
  });

  final bool enableNotification;
  final bool enableScheduleReminder;

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'];
    final data = payload is Map<String, dynamic> ? payload : json;

    return UserSettingsModel(
      enableNotification: _parseBool(data['enableNotification']),
      enableScheduleReminder: _parseBool(data['enableScheduleReminder']),
    );
  }

  Map<String, dynamic> toRequestJson() {
    return {
      'enableNotification': enableNotification,
      'enableScheduleReminder': enableScheduleReminder,
    };
  }

  static bool _parseBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }
    return false;
  }
}
