import '../../plan/domain/plan_chapter.dart';
import '../../plan/domain/study_plan.dart';
import 'calendar_day.dart';
import 'today_overview.dart';
import 'today_view.dart';

abstract interface class TodayRepository {
  TodayOverview overviewFor(
    StudyPlan plan,
    PlanChapter? chapter,
    String witnessName, {
    DateTime? date,
  });
  TodayView viewForDate(DateTime date, StudyPlan plan);
  List<CalendarDay> calendar(TodayView view, StudyPlan plan, {DateTime? date});
}
