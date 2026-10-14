class TodayOverview {
  const TodayOverview({
    required this.weekUnits,
    required this.movedDate,
    required this.missedFinishDate,
    required this.planName,
    required this.chapterName,
    required this.witnessName,
    required this.date,
    required this.finishDate,
    required this.returnFinishDate,
    required this.nextDate,
    required this.totalUnits,
    required this.unitsDone,
    required this.comebacks,
    required this.studyHours,
    required this.missedSessions,
    required this.consequence,
  });
  final int weekUnits;
  final DateTime movedDate;
  final DateTime missedFinishDate;
  final String planName;
  final String chapterName;
  final String witnessName;
  final DateTime date;
  final DateTime finishDate;
  final DateTime returnFinishDate;
  final DateTime nextDate;
  final int totalUnits;
  final int unitsDone;
  final int comebacks;
  final int studyHours;
  final int missedSessions;
  final String consequence;
}
