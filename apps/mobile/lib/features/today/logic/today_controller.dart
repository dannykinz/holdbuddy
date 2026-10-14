import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../partners/logic/plan_witnesses.dart';
import '../../plan/logic/current_chapter.dart';
import '../../plan/logic/plan_controller.dart';
import '../../session/domain/session_state.dart';
import '../../session/logic/session_controller.dart';
import '../domain/calendar_day.dart';
import '../domain/today_overview.dart';
import '../domain/today_repository.dart';
import '../domain/today_view.dart';
import 'selected_today_date.dart';

final todayRepositoryProvider = Provider<TodayRepository>(
  (ref) => throw StateError('TodayRepository must be bound at bootstrap.'),
);
final todayOverviewProvider = Provider<TodayOverview>((ref) {
  final plan = ref.watch(chosenPlanProvider);
  final witnesses = ref.watch(planWitnessesProvider(plan.id));
  return ref
      .watch(todayRepositoryProvider)
      .overviewFor(
        plan,
        ref.watch(currentChapterProvider),
        witnesses.map((peer) => peer.name).join(', '),
        date: ref.watch(SelectedTodayDate.provider),
      );
});
final todayCalendarProvider = Provider<List<CalendarDay>>(
  (ref) => ref
      .watch(todayRepositoryProvider)
      .calendar(
        ref.watch(TodayController.provider),
        ref.watch(chosenPlanProvider),
        date: ref.watch(SelectedTodayDate.provider),
      ),
);

final latestPlanReceiptProvider = Provider<SessionState?>((ref) {
  final plan = ref.watch(chosenPlanProvider);
  return ref.watch(sessionRepositoryProvider).receiptsFor(plan.id).lastOrNull;
});

class TodayController extends Notifier<TodayView> {
  static final provider = NotifierProvider<TodayController, TodayView>(
    TodayController.new,
  );
  @override
  TodayView build() => TodayView.ready;

  void chooseDate(DateTime date) {
    ref.read(SelectedTodayDate.provider.notifier).select(date);
    state = ref
        .read(todayRepositoryProvider)
        .viewForDate(date, ref.read(chosenPlanProvider));
  }

  void show(TodayView view) => state = view;
  void planCommitted() => state = TodayView.first;
  void sessionSaved({required int units, required bool first}) => state = first
      ? TodayView.firstDone
      : units > 1
      ? TodayView.twoUnitsDone
      : TodayView.done;

  DateTime get firstDay => ref.read(chosenPlanProvider).startDate;
}
