import 'study_plan.dart';

abstract interface class PlanRepository {
  Future<List<StudyPlan>> fetchPlans();
}
