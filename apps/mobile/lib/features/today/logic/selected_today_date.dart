import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../plan/logic/plan_controller.dart';

class SelectedTodayDate extends Notifier<DateTime?> {
  static final provider = NotifierProvider<SelectedTodayDate, DateTime?>(
    SelectedTodayDate.new,
  );
  @override
  DateTime? build() {
    ref.watch(chosenPlanProvider.select((plan) => plan.id));
    return null;
  }

  void select(DateTime date) =>
      state = DateTime(date.year, date.month, date.day);
}
