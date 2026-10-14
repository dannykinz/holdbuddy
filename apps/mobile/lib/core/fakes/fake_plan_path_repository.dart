import '../../features/contract/domain/contract_draft.dart';
import '../../features/contract/domain/study_contract.dart';
import '../../features/plan/domain/plan_chapter.dart';
import '../../features/plan/domain/plan_path_repository.dart';
import '../../features/plan/domain/plan_status.dart';
import '../../features/plan/domain/plan_view.dart';
import '../../features/plan/domain/study_plan.dart';
import 'fake_plan_chapters.dart';
import 'fake_seed_data.dart';

/// Fixed Figma path samples, not schedule or completion logic.
class FakePlanPathRepository implements PlanPathRepository {
  late List<StudyPlan> _plans = _seedPlans();
  @override
  List<StudyPlan> get plans => List.unmodifiable(_plans);
  @override
  void replace(StudyPlan plan) => _plans = [
    for (final existing in _plans) existing.id == plan.id ? plan : existing,
  ];
  List<StudyPlan> _seedPlans() {
    final dart = FakeSeedData(DateTime(2026, 10, 21)).plan.copyWith(
      totalUnits: 24,
      unitsDone: 6,
      witnessIds: const ['elvis', 'mum'],
      contract: FakeSeedData(DateTime(2026, 10, 21)).plan.contract
          .copyWith(time: const Duration(hours: 20)),
      targetDate: DateTime(2026, 11, 27),
    );
    return [
      dart,
      dart.copyWith(
        id: 'preview-animations',
        title: 'Flutter animations',
        status: PlanStatus.paused,
        totalUnits: 12,
        unitsDone: 2,
      ),
    ];
  }

  @override
  List<PlanChapter> chapters(PlanView view, {required String planId}) {
    final plan = _plans.where((item) => item.id == planId).firstOrNull;
    if (plan == null) return const [];
    if (plan.id == FakeSeedData.planId && plan.totalUnits == 24)
      return FakePlanChapters.chapters(view);
    final count = view == PlanView.firstWeek
        ? plan.totalUnits
        : plan.totalUnits.clamp(0, 7).toInt();
    return List.generate(
      count,
      (index) => PlanChapter(
        number: index + 1,
        name: plan.unitName + ' ' + (index + 1).toString(),
        date: plan.startDate.add(Duration(days: index)).add(plan.contract.time),
      ),
    );
  }

  @override
  StudyPlan create(
    ContractDraft draft,
    DateTime finish,
    List<String> witnessIds,
  ) {
    final id = 'preview-created-' + _plans.length.toString();
    final plan = FakeSeedData(draft.startDate).plan.copyWith(
      id: id,
      title: draft.title,
      totalUnits: draft.totalUnits,
      unitName: draft.unitName,
      unitsDone: 0,
      startDate: draft.startDate,
      targetDate: finish,
      status: PlanStatus.active,
      contract: _contract(draft, id),
      witnessIds: witnessIds,
    );
    _plans = [..._plans, plan];
    return plan;
  }

  StudyContract _contract(ContractDraft draft, String id) => StudyContract(
    planId: id,
    days: draft.days,
    time: Duration(minutes: draft.startMinute),
    duration: Duration(minutes: draft.sessionMinutes),
    unitsPerSession: draft.unitsPerSession,
    consequenceMessage: draft.message,
    committedAt: DateTime.now(),
  );
}
