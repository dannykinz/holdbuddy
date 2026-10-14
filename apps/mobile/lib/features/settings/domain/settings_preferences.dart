import 'appearance_mode.dart';

class SettingsPreferences {
  const SettingsPreferences({
    required this.appearance,
    required this.reminderMinute,
    required this.beforeMinutes,
    required this.remindersEnabled,
  });
  final AppearanceMode appearance;
  final int reminderMinute;
  final int beforeMinutes;
  final bool remindersEnabled;
  SettingsPreferences copyWith({
    AppearanceMode? appearance,
    int? reminderMinute,
    int? beforeMinutes,
    bool? remindersEnabled,
  }) => SettingsPreferences(
    appearance: appearance ?? this.appearance,
    reminderMinute: reminderMinute ?? this.reminderMinute,
    beforeMinutes: beforeMinutes ?? this.beforeMinutes,
    remindersEnabled: remindersEnabled ?? this.remindersEnabled,
  );
}
