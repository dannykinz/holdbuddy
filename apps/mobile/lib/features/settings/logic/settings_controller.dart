import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/logger.dart';
import '../domain/appearance_mode.dart';
import '../domain/settings_preferences.dart';
import '../domain/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => throw StateError('SettingsRepository must be bound at bootstrap.'),
);
final settingsPreviewProvider = Provider(
  (ref) => ref.watch(settingsRepositoryProvider).preview,
);

class SettingsController extends Notifier<SettingsPreferences> {
  static final provider =
      NotifierProvider<SettingsController, SettingsPreferences>(
        SettingsController.new,
      );
  @override
  SettingsPreferences build() =>
      ref.read(settingsRepositoryProvider).preferences;
  void appearance(AppearanceMode mode) =>
      _save(state.copyWith(appearance: mode));
  void reminderMinute(int minute) {
    if (minute < 0 || minute >= 1440) return;
    _save(state.copyWith(reminderMinute: minute));
  }

  void beforeMinutes(int minutes) {
    if (minutes < 0 || minutes > 60) return;
    _save(state.copyWith(beforeMinutes: minutes));
  }

  bool enableReminders() {
    try {
      final enabled = ref
          .read(settingsRepositoryProvider)
          .requestReminderPermission();
      _save(state.copyWith(remindersEnabled: enabled));
      return enabled && !ref.read(settingsSaveFailureProvider);
    } catch (error, stack) {
      logError(error, stack);
      ref.read(settingsSaveFailureProvider.notifier).update(true);
      return false;
    }
  }

  void keepRemindersOff() => _save(state.copyWith(remindersEnabled: false));
  void _save(SettingsPreferences preferences) {
    try {
      ref.read(settingsRepositoryProvider).save(preferences);
      state = preferences;
      ref.read(settingsSaveFailureProvider.notifier).update(false);
    } catch (error, stack) {
      logError(error, stack);
      ref.read(settingsSaveFailureProvider.notifier).update(true);
    }
  }
}

final settingsSaveFailureProvider =
    NotifierProvider<_SettingsSaveFailure, bool>(_SettingsSaveFailure.new);

class _SettingsSaveFailure extends Notifier<bool> {
  @override
  bool build() => false;
  void update(bool failed) => state = failed;
}
