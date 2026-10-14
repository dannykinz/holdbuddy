import 'progress_day.dart';
import 'progress_milestone.dart';

class ProgressSnapshot {
  ProgressSnapshot({
    required List<ProgressDay> days,
    required List<ProgressMilestone> milestones,
    required this.minutes,
    required this.targetMinutes,
    required this.sessions,
    required this.notes,
    required this.comebacks,
    required this.totalSessions,
    required this.totalMinutes,
    required this.totalComebacks,
  }) : days = List.unmodifiable(days),
       milestones = List.unmodifiable(milestones);
  final List<ProgressDay> days;
  final List<ProgressMilestone> milestones;
  final int minutes;
  final int targetMinutes;
  final int sessions;
  final int notes;
  final int comebacks;
  final int totalSessions;
  final int totalMinutes;
  final int totalComebacks;
}
