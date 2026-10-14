import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../plan/logic/current_chapter.dart';
import '../../plan/logic/plan_controller.dart';
import '../domain/note_repository.dart';
import '../domain/study_note.dart';

final noteRepositoryProvider = Provider<NoteRepository>(
  (ref) => throw StateError('NoteRepository must be bound at bootstrap.'),
);

final noteDraftProvider = Provider<StudyNote>((ref) {
  final draft = ref.watch(noteRepositoryProvider).draft;
  final plan = ref.watch(chosenPlanProvider);
  if (draft.planId == plan.id) return draft;
  final chapter = ref.watch(currentChapterProvider);
  return draft.copyWith(
    planId: plan.id,
    chapter: chapter?.number ?? 1,
    chapterName: chapter?.name ?? plan.title,
    body: '',
  );
});

class NoteController extends Notifier<List<StudyNote>> {
  static final provider = NotifierProvider<NoteController, List<StudyNote>>(
    NoteController.new,
  );
  @override
  List<StudyNote> build() {
    ref.watch(chosenPlanProvider);
    return _notes();
  }

  List<StudyNote> _notes() => ref
      .read(noteRepositoryProvider)
      .notes
      .where((note) => note.planId == ref.read(chosenPlanProvider).id)
      .toList();
  void save(StudyNote note) {
    if (note.body.trim().isEmpty) return;
    final planId = note.planId.isEmpty
        ? ref.read(chosenPlanProvider).id
        : note.planId;
    final repository = ref.read(noteRepositoryProvider);
    final previous = repository.notes
        .where(
          (value) => value.planId == planId && value.chapter == note.chapter,
        )
        .firstOrNull;
    repository.save(
      note.copyWith(
        body: note.body.trim(),
        planId: planId,
        category: previous?.category ?? note.category,
      ),
    );
    state = _notes();
  }

  void remove(String id) {
    ref.read(noteRepositoryProvider).remove(id);
    state = _notes();
  }
}
