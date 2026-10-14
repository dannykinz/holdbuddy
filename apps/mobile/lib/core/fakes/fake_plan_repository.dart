import '../../features/plan/domain/plan_repository.dart';
import '../../features/plan/domain/study_plan.dart';

/// Read-only in-memory fake for the UI phase, with no persistence or network.
class FakePlanRepository implements PlanRepository {
  FakePlanRepository(List<StudyPlan> plans) : _plans = List.unmodifiable(plans);

  final List<StudyPlan> _plans;

  @override
  Future<List<StudyPlan>> fetchPlans() async => _plans;
}
