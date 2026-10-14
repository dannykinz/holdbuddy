import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_category.dart';
import '../domain/deadline_category.dart';
import '../domain/deadline_schedule.dart';

abstract final class DeadlineCopy {
  static String category(AppLocalizations l, DeadlineCategory category) =>
      switch (category) {
        DeadlineCategory.school => l.deadlineSchool,
        DeadlineCategory.admin => l.deadlineAdmin,
        DeadlineCategory.personal => l.deadlinePersonal,
      };
  static HbCategory color(DateTime dueAt) {
    final days = DeadlineSchedule.daysBetween(dueAt, DateTime.now());
    if (days <= 21) return HbCategory.orange;
    return days <= 28 ? HbCategory.sky : HbCategory.purple;
  }

  static String timing(AppLocalizations l, DateTime dueAt) {
    final days = DeadlineSchedule.daysBetween(dueAt, DateTime.now());
    if (days == 0) return l.deadlineDueToday;
    return days < 0 ? l.deadlineOverdue(-days) : l.deadlineDaysAway(days);
  }

  static String finished(AppLocalizations l, DateTime dueAt, DateTime doneAt) {
    final days = DeadlineSchedule.daysBetween(dueAt, doneAt);
    if (days == 0) return l.deadlineFinishedOnDay;
    return days > 0 ? l.deadlineEarly(days) : l.deadlineLate(-days);
  }

  static String stop(AppLocalizations l, int offset, {bool short = false}) {
    if (offset == 0) return short ? l.deadlineDayShort : l.deadlineOnDay;
    if (short)
      return offset >= 7
          ? l.deadlineStopWeeksShort(offset ~/ 7)
          : l.deadlineStopDaysShort(offset);
    return offset >= 7
        ? l.deadlineWeeksBefore(offset ~/ 7)
        : l.deadlineDaysBefore(offset);
  }
}
