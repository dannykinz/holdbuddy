import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../plan/domain/plan_chapter.dart';
import '../../plan/domain/plan_view.dart';
import '../../plan/domain/study_plan.dart';
import '../../plan/logic/plan_controller.dart';
import 'session_controller.dart';

final sessionPlanProvider = Provider<StudyPlan?>((ref) {
  final planId = ref.watch(SessionController.provider).planId;
  return ref
      .watch(planChoicesProvider)
      .where((plan) => plan.id == planId)
      .firstOrNull;
});
final sessionNextChapterProvider = Provider<PlanChapter?>((ref) {
  final session = ref.watch(SessionController.provider);
  return ref
      .watch(planPathRepositoryProvider)
      .chapters(PlanView.firstWeek, planId: session.planId)
      .where(
        (chapter) => chapter.number == session.chapterNumber + session.units,
      )
      .firstOrNull;
});
