import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/core/fakes/fake_repository_overrides.dart';
import 'package:holdbuddy/features/plan/logic/chosen_plan.dart';
import 'package:holdbuddy/features/plan/logic/plan_controller.dart';
import 'package:holdbuddy/features/session/logic/session_controller.dart';
import 'package:holdbuddy/features/today/domain/calendar_status.dart';
import 'package:holdbuddy/features/today/domain/today_view.dart';
import 'package:holdbuddy/features/today/logic/selected_today_date.dart';
import 'package:holdbuddy/features/today/logic/today_controller.dart';

void main() {
  late ProviderContainer container;
  setUp(
    () => container = ProviderContainer(overrides: fakeRepositoryOverrides()),
  );
  tearDown(() => container.dispose());
  test(
    'Changing plan removes unrelated Today aggregates',
    () => _planContext(container),
  );
  test(
    'Calendar follows the selected week and resets for another plan',
    () => _calendarContext(container),
  );
  test(
    'Saved receipt updates only its plan totals',
    () => _savedTotals(container),
  );
}

void _planContext(ProviderContainer container) {
  container.read(ChosenPlan.provider.notifier).select('preview-animations');
  final overview = container.read(todayOverviewProvider);
  final plan = container.read(chosenPlanProvider);
  expect(overview.planName, 'Flutter animations');
  expect(overview.totalUnits, 12);
  expect(overview.unitsDone, 2);
  expect(overview.chapterName, 'chapter 3');
  expect(overview.finishDate, plan.targetDate);
  expect(overview.studyHours, 0);
  expect(overview.weekUnits, 0);
  expect(overview.comebacks, 0);
}

void _calendarContext(ProviderContainer container) {
  final day = DateTime(2026, 11, 2);
  container.read(TodayController.provider.notifier).chooseDate(day);
  expect(container.read(todayOverviewProvider).date, day);
  final week = container.read(todayCalendarProvider);
  expect(week.first.date, day);
  expect(week.first.status, CalendarStatus.today);
  container.read(ChosenPlan.provider.notifier).select('preview-animations');
  expect(container.read(SelectedTodayDate.provider), isNull);
  final start = container.read(chosenPlanProvider).startDate;
  expect(container.read(todayOverviewProvider).date, start);
}

void _savedTotals(ProviderContainer container) {
  final controller = container.read(SessionController.provider.notifier);
  controller.begin(first: false, chapterNumber: 7);
  controller.pause();
  controller.setUnits(2);
  controller.save();
  container
      .read(TodayController.provider.notifier)
      .sessionSaved(units: 2, first: false);
  expect(container.read(todayOverviewProvider).unitsDone, 8);
  expect(container.read(todayOverviewProvider).weekUnits, 5);
  expect(container.read(latestPlanReceiptProvider)?.chapterNumber, 7);
  expect(
    container
        .read(todayCalendarProvider)
        .where((day) => day.date == DateTime(2026, 10, 21))
        .single
        .status,
    CalendarStatus.done,
  );
  expect(container.read(TodayController.provider), TodayView.twoUnitsDone);
  container.read(ChosenPlan.provider.notifier).select('preview-animations');
  expect(container.read(todayOverviewProvider).unitsDone, 2);
  expect(container.read(latestPlanReceiptProvider), isNull);
}
