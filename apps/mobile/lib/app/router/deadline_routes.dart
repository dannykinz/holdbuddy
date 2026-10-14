import 'package:flutter/material.dart';

import '../../features/deadlines/domain/deadline.dart';
import '../../features/deadlines/ui/reminder_detail_screen.dart';
import '../../features/deadlines/ui/reminder_form_screen.dart';
import '../../features/deadlines/ui/reminders_screen.dart';
import 'app_route.dart';

abstract final class DeadlineRoutes {
  static Widget? screen(AppRoute route, {Object? extra}) => switch (route) {
    AppRoute.reminders => const RemindersScreen(),
    AppRoute.remindersSwipeActions => const RemindersScreen(revealFirst: true),
    AppRoute.reminderNew => ReminderFormScreen(
      existing: extra is Deadline ? extra : null,
    ),
    AppRoute.reminderDetail => ReminderDetailScreen(
      deadlineId: extra is String ? extra : null,
    ),
    _ => null,
  };
}
