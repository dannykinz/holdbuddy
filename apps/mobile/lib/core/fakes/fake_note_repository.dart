import '../../features/notes/domain/note_category.dart';
import '../../features/notes/domain/note_repository.dart';
import '../../features/notes/domain/study_note.dart';
import 'fake_seed_data.dart';

/// Private in-memory note previews. Notes never use the network.
class FakeNoteRepository implements NoteRepository {
  final _notes = [
    StudyNote(
      planId: FakeSeedData.planId,
      id: 'preview-futures',
      chapter: 7,
      chapterName: 'Futures & async',
      recallQuestion: 'How is await different from blocking the whole app?',
      body: 'A Future is a value that arrives later.\n\nAwait pauses this function, not the whole app.',
      createdAt: DateTime(2026, 10, 21),
    ),
    StudyNote(
      planId: FakeSeedData.planId,
      id: 'preview-functions',
      category: NoteCategory.orange,
      chapter: 6,
      chapterName: 'Functions',
      body: 'Named parameters make call sites easier to read.',
      createdAt: DateTime(2026, 10, 19),
    ),
    StudyNote(
      planId: FakeSeedData.planId,
      id: 'preview-lists',
      category: NoteCategory.sky,
      chapter: 5,
      chapterName: 'Lists',
      body: 'Spread copies, it does not share.',
      createdAt: DateTime(2026, 10, 17),
    ),
  ];
  @override
  StudyNote get draft => StudyNote(
    planId: FakeSeedData.planId,
    id: 'preview-draft',
    chapter: 7,
    chapterName: 'Futures & async',
    body: 'A Future is a value that arrives later. Await pauses this function, not the whole app.',
    createdAt: DateTime(2026, 10, 21),
  );
  @override
  List<StudyNote> get notes => List.unmodifiable(_notes);
  @override
  void save(StudyNote note) {
    final index = _notes.indexWhere((value) => value.id == note.id);
    if (index < 0) {
      _notes.insert(0, note);
      return;
    }
    _notes[index] = note;
  }

  @override
  void remove(String id) => _notes.removeWhere((note) => note.id == id);
}
