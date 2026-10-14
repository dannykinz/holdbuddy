class ProgressDay {
  const ProgressDay({
    required this.date,
    required this.minutes,
    this.missed = false,
    this.current = false,
  });
  final DateTime date;
  final int minutes;
  final bool missed;
  final bool current;
}
