import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/plan_repository.dart';
import '../domain/study_plan.dart';

final planRepositoryProvider = Provider<PlanRepository>(
  (ref) => throw StateError('PlanRepository must be bound at bootstrap.'),
);

final plansProvider = FutureProvider<List<StudyPlan>>(
  (ref) => ref.watch(planRepositoryProvider).fetchPlans(),
);
