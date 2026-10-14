import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/plan_chapter.dart';
import '../domain/plan_path_repository.dart';
import '../domain/plan_view.dart';
import '../domain/study_plan.dart';
import 'chosen_plan.dart';

final planPathRepositoryProvider = Provider<PlanPathRepository>(
  (ref) => throw StateError('PlanPathRepository must be bound at bootstrap.'),
);
final planChoicesProvider = Provider<List<StudyPlan>>(
  (ref) => ref.watch(planPathRepositoryProvider).plans,
);
final chosenPlanProvider = Provider<StudyPlan>((ref) {
  final plans = ref.watch(planChoicesProvider);
  final id = ref.watch(ChosenPlan.provider);
  return plans.where((plan) => plan.id == id).firstOrNull ?? plans.first;
});
final planChaptersProvider = Provider.family<List<PlanChapter>, PlanView>(
  (ref, view) => ref
      .watch(planPathRepositoryProvider)
      .chapters(view, planId: ref.watch(chosenPlanProvider).id),
);

class PlanController extends Notifier<PlanView> {
  static final provider = NotifierProvider<PlanController, PlanView>(
    PlanController.new,
  );
  @override
  PlanView build() => PlanView.path;
  void show(PlanView view) => state = view;
}
