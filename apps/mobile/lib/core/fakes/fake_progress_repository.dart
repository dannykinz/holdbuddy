import '../../features/today/domain/milestone_kind.dart';
import '../../features/today/domain/progress_day.dart';
import '../../features/today/domain/progress_milestone.dart';
import '../../features/today/domain/progress_period.dart';
import '../../features/today/domain/progress_repository.dart';
import '../../features/today/domain/progress_snapshot.dart';

/// Figma activity samples. No stored session statistics are claimed.
class FakeProgressRepository implements ProgressRepository {
  static const _milestones = [
    ProgressMilestone(kind: MilestoneKind.comeback, done: 1, total: 1),
    ProgressMilestone(kind: MilestoneKind.halfway, done: 6, total: 12),
    ProgressMilestone(kind: MilestoneKind.notes, done: 9, total: 10),
    ProgressMilestone(kind: MilestoneKind.finish, done: 6, total: 24),
  ];
  @override
  ProgressSnapshot snapshot(ProgressPeriod period) {
    final week = period == ProgressPeriod.week;
    final values = week ? [45, 40, 0, 0, 28, 0, 0] : [80, 130, 160, 180];
    return ProgressSnapshot(
      days: List.generate(
        values.length,
        (index) => ProgressDay(
          date: week
              ? DateTime(2022, 10, 17 + index)
              : period == ProgressPeriod.month
              ? DateTime(2026, 10, 1 + index * 7)
              : DateTime(2026, 7 + index),
          minutes: values[index],
          missed: week && index == 2,
          current: week && index == 4,
        ),
      ),
      milestones: _milestones,
      minutes: week ? 113 : 550,
      targetMinutes: week ? 225 : 900,
      sessions: week ? 3 : 12,
      notes: week ? 4 : 9,
      comebacks: week ? 1 : 2,
      totalSessions: 12,
      totalMinutes: 550,
      totalComebacks: 2,
    );
  }
}
