import '../../plan/domain/plan_chapter.dart';
import '../../plan/domain/study_plan.dart';
import 'session_state.dart';

abstract interface class SessionRepository {
  SessionState preview({
    required bool first,
    required StudyPlan plan,
    required PlanChapter chapter,
  });
  void saveNote(SessionState session);
  void saveReceipt(SessionState session);
  List<SessionState> receiptsFor(String planId);
}
