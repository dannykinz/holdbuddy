import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_route.dart';
import '../domain/settings_pane.dart';
import '../logic/settings_navigation.dart';
import 'widgets/blocked_people.dart';
import 'widgets/session_reminder_preferences.dart';
import 'widgets/session_reminder_result.dart';
import 'widgets/settings_home.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pane = ref.watch(SettingsNavigation.provider);
    return PopScope(
      canPop: pane == SettingsPane.home,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop)
          ref
              .read(SettingsNavigation.provider.notifier)
              .open(SettingsPane.home);
      },
      child: KeyedSubtree(
        key: const ValueKey(AppRoute.settings),
        child: switch (pane) {
          SettingsPane.home => const SettingsHome(),
          SettingsPane.blocked => const BlockedPeople(),
          SettingsPane.reminders => const SessionReminderPreferences(),
          _ => SessionReminderResult(
            enabled: pane == SettingsPane.remindersEnabled,
          ),
        },
      ),
    );
  }
}
