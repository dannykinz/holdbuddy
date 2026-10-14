import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/plan_chapter.dart';
import '../domain/plan_view.dart';
import 'plan_controller.dart';

final currentChapterProvider = Provider<PlanChapter?>((ref) {
  final plan = ref.watch(chosenPlanProvider);
  if (plan.totalUnits < 1 || plan.unitsDone >= plan.totalUnits) return null;
  final chapters = ref.watch(planChaptersProvider(PlanView.firstWeek));
  final number = (plan.unitsDone + 1).clamp(1, plan.totalUnits);
  return chapters.where((chapter) => chapter.number == number).firstOrNull ??
      chapters.firstOrNull;
});

final chapterProvider = Provider.family<PlanChapter?, int?>((ref, number) {
  if (number == null) return ref.watch(currentChapterProvider);
  return ref
      .watch(planChaptersProvider(PlanView.firstWeek))
      .where((chapter) => chapter.number == number)
      .firstOrNull;
});
