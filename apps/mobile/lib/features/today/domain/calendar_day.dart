import 'calendar_status.dart';

class CalendarDay {
  const CalendarDay({required this.date, required this.status});
  final DateTime date;
  final CalendarStatus status;
}
