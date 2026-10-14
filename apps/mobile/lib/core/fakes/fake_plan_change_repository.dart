import '../../features/plan/domain/plan_change.dart';
import '../../features/plan/domain/plan_change_kind.dart';
import '../../features/plan/domain/plan_change_repository.dart';
import '../../features/plan/domain/study_plan.dart';

/// Figma fixtures in memory. Finish dates are samples, not a scheduler.
class FakePlanChangeRepository implements PlanChangeRepository {
  final Map<String, PlanChange> _saved = {};
  @override
  PlanChange prepare(StudyPlan plan, PlanChangeKind kind) {
    final finish = DateTime(
      2026,
      kind == PlanChangeKind.scope ? 11 : 12,
      kind == PlanChangeKind.scope ? 13 : 18,
    );
    final contract = plan.contract.copyWith(
      days: kind == PlanChangeKind.rhythm ? [1, 5] : plan.contract.days,
    );
    return PlanChange(
      kind: kind,
      plan: plan.copyWith(
        contract: contract,
        totalUnits: kind == PlanChangeKind.scope ? 18 : plan.totalUnits,
        targetDate: kind == PlanChangeKind.other ? plan.targetDate : finish,
      ),
      projectedFinish: kind == PlanChangeKind.other
          ? plan.targetDate
          : kind == PlanChangeKind.target
          ? DateTime(2026, 11, 27)
          : finish,
      reason: kind == PlanChangeKind.scope
          ? 'Focus on the language essentials'
          : 'My evenings have changed',
    );
  }

  @override
  void save(PlanChange change) => _saved[change.plan.id] = change;
  @override
  PlanChange? changeFor(String planId) => _saved[planId];
}
