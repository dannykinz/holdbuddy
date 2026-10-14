import '../../features/settings/domain/appearance_mode.dart';
import '../../features/settings/domain/settings_preferences.dart';
import '../../features/settings/domain/settings_preview.dart';
import '../../features/settings/domain/settings_repository.dart';

/// In-memory UI preview. No permissions, notifications or device storage change.
class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository({this.permissionAllowed = true});
  final bool permissionAllowed;
  SettingsPreferences _preferences = const SettingsPreferences(
    appearance: AppearanceMode.light,
    reminderMinute: 1200,
    beforeMinutes: 0,
    remindersEnabled: false,
  );
  @override
  SettingsPreferences get preferences => _preferences;
  @override
  SettingsPreview get preview => const SettingsPreview(
    email: 'danny@example.com',
    partners: ['Elvis', 'Mum', 'Amaka'],
    files: 4,
    deadlines: 3,
    blocked: 1,
  );
  @override
  void save(SettingsPreferences preferences) => _preferences = preferences;
  @override
  bool requestReminderPermission() => permissionAllowed;
}
