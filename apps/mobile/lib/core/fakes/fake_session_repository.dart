import '../../features/plan/domain/plan_chapter.dart';
import '../../features/plan/domain/plan_path_repository.dart';
import '../../features/plan/domain/study_plan.dart';
import '../../features/session/domain/session_repository.dart';
import '../../features/session/domain/session_state.dart';
import 'fake_seed_data.dart';

/// Session previews and receipts remain private and in memory only.
class FakeSessionRepository implements SessionRepository {
  FakeSessionRepository(this._plans);
  final PlanPathRepository _plans;
  final _receipts = <SessionState>[];
  static const _sampleNote =
      'A Future is a value that arrives later.\n\nAwait pauses this function, not the whole app.';
  final _notes = <String, String>{};
  String _key(String planId, int chapter) => planId + ':' + chapter.toString();
  @override
  SessionState preview({
    required bool first,
    required StudyPlan plan,
    required PlanChapter chapter,
  }) {
    final sample =
        !first && plan.id == FakeSeedData.planId && chapter.number == 7;
    final elapsed = sample
        ? 832.clamp(0, plan.contract.duration.inSeconds).toInt()
        : 0;
    return SessionState(
      planId: plan.id,
      chapterNumber: chapter.number,
      chapterName: chapter.name,
      planName: plan.title,
      remainingSeconds: plan.contract.duration.inSeconds - elapsed,
      elapsedSeconds: elapsed,
      note:
          _notes[_key(plan.id, chapter.number)] ?? (sample ? _sampleNote : ''),
      isFirst: first,
    );
  }

  @override
  void saveNote(SessionState session) =>
      _notes[_key(session.planId, session.chapterNumber)] = session.note;
  @override
  void saveReceipt(SessionState session) {
    if (_receipts.contains(session)) return;
    final plan = _plans.plans
        .where((plan) => plan.id == session.planId)
        .firstOrNull;
    if (plan == null) throw StateError('The session plan is unavailable.');
    final done = (plan.unitsDone + session.units)
        .clamp(0, plan.totalUnits)
        .toInt();
    _plans.replace(plan.copyWith(unitsDone: done));
    _receipts.add(session);
  }

  @override
  List<SessionState> receiptsFor(String planId) =>
      List.unmodifiable(_receipts.where((session) => session.planId == planId));
}
