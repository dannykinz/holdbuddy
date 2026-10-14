import '../../contract/domain/contract_draft.dart';
import 'plan_chapter.dart';
import 'plan_view.dart';
import 'study_plan.dart';

abstract interface class PlanPathRepository {
  List<StudyPlan> get plans;
  void replace(StudyPlan plan);
  StudyPlan create(
    ContractDraft draft,
    DateTime finish,
    List<String> witnessIds,
  );
  List<PlanChapter> chapters(PlanView view, {required String planId});
}
