import 'plan_change.dart';
import 'plan_change_kind.dart';
import 'study_plan.dart';

abstract interface class PlanChangeRepository {
  PlanChange prepare(StudyPlan plan, PlanChangeKind kind);
  void save(PlanChange change);
  PlanChange? changeFor(String planId);
}
