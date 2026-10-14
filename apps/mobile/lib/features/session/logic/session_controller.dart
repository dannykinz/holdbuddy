import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../focus/logic/focus_controller.dart';
import '../../material/logic/audio_controller.dart';
import '../../notes/domain/study_note.dart';
import '../../notes/logic/note_controller.dart';
import '../../plan/domain/plan_chapter.dart';
import '../../plan/domain/plan_view.dart';
import '../../plan/logic/chosen_plan.dart';
import '../../plan/logic/current_chapter.dart';
import '../../plan/logic/plan_controller.dart';
import '../domain/session_repository.dart';
import '../domain/session_stage.dart';
import '../domain/session_state.dart';

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => throw StateError('SessionRepository must be bound at bootstrap.'),
);

class SessionController extends Notifier<SessionState> {
  static final provider = NotifierProvider<SessionController, SessionState>(
    SessionController.new,
  );
  Timer? _timer;
  bool _started = false;
  bool get hasUnfinishedSession => _started;
  bool get isActive =>
      _started &&
      (state.stage == SessionStage.running ||
          state.stage == SessionStage.paused ||
          state.stage == SessionStage.leave);

  @override
  SessionState build() {
    ref.onDispose(() => _timer?.cancel());
    return _preview(
      first: false,
      chapter:
          ref.read(currentChapterProvider) ??
          ref.read(planChaptersProvider(PlanView.firstWeek)).lastOrNull,
    );
  }

  void begin({required bool first, int? chapterNumber}) {
    if (_started) {
      ref.read(ChosenPlan.provider.notifier).select(state.planId);
      return;
    }
    final chapter = ref.read(chapterProvider(chapterNumber));
    state = _preview(first: first, chapter: chapter);
    _started = true;
    resume();
  }

  SessionState _preview({required bool first, required PlanChapter? chapter}) {
    if (chapter == null)
      throw StateError('A session needs an available chapter.');
    return ref
        .read(sessionRepositoryProvider)
        .preview(
          first: first,
          plan: ref.read(chosenPlanProvider),
          chapter: chapter,
        );
  }

  void resume() {
    _started = true;
    _timer?.cancel();
    ref.read(FocusController.provider.notifier).beginSession();
    state = state.copyWith(stage: SessionStage.running);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (state.stage != SessionStage.running) return;
    if (state.remainingSeconds <= 0) {
      end();
      return;
    }
    state = state.copyWith(
      remainingSeconds: state.remainingSeconds - 1,
      elapsedSeconds: state.elapsedSeconds + 1,
    );
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(stage: SessionStage.paused);
  }

  void leave() {
    pause();
    state = state.copyWith(stage: SessionStage.leave);
  }

  void keepStudying() => resume();
  void saveNote(String note) {
    final updated = state.copyWith(note: note);
    ref.read(sessionRepositoryProvider).saveNote(updated);
    state = updated;
  }

  void end() {
    _timer?.cancel();
    ref.read(FocusController.provider.notifier).endSession();
    ref.read(AudioController.provider.notifier).pause();
    state = state.copyWith(
      stage: state.isFirst ? SessionStage.firstSaved : SessionStage.receipt,
    );
  }

  void setUnits(int count) {
    final plan = ref
        .read(planChoicesProvider)
        .where((plan) => plan.id == state.planId)
        .firstOrNull;
    if (plan == null || count < 0 || count > plan.totalUnits - plan.unitsDone)
      return;
    state = state.copyWith(
      units: count,
      stage: count == 0 ? SessionStage.noUnits : SessionStage.receipt,
    );
  }

  void save() {
    if (!_started) return;
    ref.read(sessionRepositoryProvider).saveReceipt(state);
    if (state.note.trim().isNotEmpty)
      ref
          .read(NoteController.provider.notifier)
          .save(
            StudyNote(
              id: 'session-' + DateTime.now().microsecondsSinceEpoch.toString(),
              planId: state.planId,
              chapter: state.chapterNumber,
              chapterName: state.chapterName,
              body: state.note,
              createdAt: DateTime.now(),
            ),
          );
    _started = false;
    ref.invalidate(planChoicesProvider);
  }
}
