import 'settings_preferences.dart';
import 'settings_preview.dart';

abstract interface class SettingsRepository {
  SettingsPreferences get preferences;
  SettingsPreview get preview;
  void save(SettingsPreferences preferences);
  bool requestReminderPermission();
}
