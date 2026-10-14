abstract final class DeadlineSchedule {
  static int daysBetween(DateTime later, DateTime earlier) => DateTime.utc(
    later.year,
    later.month,
    later.day,
  ).difference(DateTime.utc(earlier.year, earlier.month, earlier.day)).inDays;
  static DateTime day(DateTime date) =>
      DateTime(date.year, date.month, date.day);
  static List<int> offsets(DateTime dueAt, DateTime now) =>
      daysBetween(dueAt, now) > 21 ? const [21, 14, 7, 0] : const [3, 2, 1, 0];
  static DateTime stopDate(DateTime dueAt, int offset) =>
      DateTime(dueAt.year, dueAt.month, dueAt.day - offset);
}
