import 'plan_change_kind.dart';
import 'study_plan.dart';

class PlanChange {
  const PlanChange({
    required this.kind,
    required this.plan,
    required this.projectedFinish,
    this.reason = '',
  });
  final PlanChangeKind kind;
  final StudyPlan plan;
  final DateTime projectedFinish;
  final String reason;
  bool get isValid =>
      plan.totalUnits >= plan.unitsDone &&
      plan.totalUnits > 0 &&
      plan.contract.days.isNotEmpty &&
      plan.contract.duration.inMinutes > 0 &&
      plan.contract.consequenceMessage.trim().isNotEmpty &&
      !plan.targetDate.isBefore(plan.startDate);
  PlanChange copyWith({StudyPlan? plan, String? reason}) => PlanChange(
    kind: kind,
    plan: plan ?? this.plan,
    projectedFinish: projectedFinish,
    reason: reason ?? this.reason,
  );
}
