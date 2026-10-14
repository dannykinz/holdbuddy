import '../../features/plan/domain/plan_chapter.dart';
import '../../features/plan/domain/study_plan.dart';
import '../../features/session/domain/session_repository.dart';
import '../../features/today/domain/calendar_day.dart';
import '../../features/today/domain/calendar_status.dart';
import '../../features/today/domain/today_overview.dart';
import '../../features/today/domain/today_repository.dart';
import '../../features/today/domain/today_view.dart';
import 'fake_seed_data.dart';

/// In-memory plan context with fixed recovery offsets, not a scheduler.
class FakeTodayRepository implements TodayRepository {
  FakeTodayRepository(this._sessions);
  final SessionRepository _sessions;
  static const _week = [
    CalendarStatus.done,
    CalendarStatus.missed,
    CalendarStatus.today,
    CalendarStatus.rest,
    CalendarStatus.planned,
    CalendarStatus.rest,
    CalendarStatus.rest,
  ];
  @override
  TodayOverview overviewFor(
    StudyPlan plan,
    PlanChapter? chapter,
    String witnessName, {
    DateTime? date,
  }) {
    final seed = plan.id == FakeSeedData.planId;
    final stats = _stats(plan.id);
    final day = date ?? (seed ? DateTime(2026, 10, 21) : plan.startDate);
    return TodayOverview(
      weekUnits: (seed ? 3 : 0) + stats.units,
      movedDate: day.add(const Duration(days: 1)).add(plan.contract.time),
      missedFinishDate: plan.targetDate.add(const Duration(days: 3)),
      planName: plan.title,
      chapterName: chapter?.name ?? plan.title,
      witnessName: witnessName,
      date: day,
      finishDate: plan.targetDate,
      returnFinishDate: plan.targetDate.add(const Duration(days: 7)),
      nextDate: chapter?.date ?? day.add(plan.contract.time),
      totalUnits: plan.totalUnits,
      unitsDone: plan.unitsDone,
      comebacks: seed ? 2 : 0,
      studyHours: (seed ? 9 : 0) + stats.seconds ~/ 3600,
      missedSessions: seed ? 3 : 0,
      consequence: plan.contract.consequenceMessage,
    );
  }

  ({int units, int seconds}) _stats(String planId) {
    final receipts = _sessions.receiptsFor(planId);
    return (
      units: receipts.fold(0, (sum, session) => sum + session.units),
      seconds: receipts.fold(0, (sum, session) => sum + session.elapsedSeconds),
    );
  }

  @override
  TodayView viewForDate(DateTime date, StudyPlan plan) {
    if (!plan.contract.days.contains(date.weekday)) return TodayView.rest;
    if (plan.unitsDone == 0) return TodayView.first;
    return TodayView.ready;
  }

  @override
  List<CalendarDay> calendar(TodayView view, StudyPlan plan, {DateTime? date}) {
    final first = view == TodayView.first || view == TodayView.firstDone;
    final anchor =
        date ??
        (first || plan.id != FakeSeedData.planId
            ? plan.startDate
            : DateTime(2026, 10, 21));
    final start = anchor.subtract(Duration(days: anchor.weekday - 1));
    return List.generate(7, (index) {
      final date = start.add(Duration(days: index));
      return CalendarDay(
        date: date,
        status: _status(view, plan, date, anchor, index),
      );
    });
  }

  CalendarStatus _status(
    TodayView view,
    StudyPlan plan,
    DateTime date,
    DateTime anchor,
    int index,
  ) {
    if ((view == TodayView.firstDone ||
            view == TodayView.done ||
            view == TodayView.twoUnitsDone) &&
        date == anchor)
      return CalendarStatus.done;
    if (view == TodayView.ready &&
        plan.id == FakeSeedData.planId &&
        anchor == DateTime(2026, 10, 21))
      return _week[index];
    if (date == anchor) return CalendarStatus.today;
    return plan.contract.days.contains(date.weekday)
        ? CalendarStatus.planned
        : CalendarStatus.rest;
  }
}
