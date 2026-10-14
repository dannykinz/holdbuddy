import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/study_note.dart';
import 'note_controller.dart';

class NoteSearch extends Notifier<String> {
  static final provider = NotifierProvider<NoteSearch, String>(NoteSearch.new);
  @override
  String build() => '';
  void search(String value) => state = value.trim().toLowerCase();
}

final filteredNotesProvider = Provider<List<StudyNote>>((ref) {
  final query = ref.watch(NoteSearch.provider);
  return ref
      .watch(NoteController.provider)
      .where(
        (note) =>
            note.chapterName.toLowerCase().contains(query) ||
            note.body.toLowerCase().contains(query),
      )
      .toList();
});
final selectedNoteProvider = Provider.family<StudyNote?, String?>((ref, id) {
  final notes = ref.watch(NoteController.provider);
  if (id == null) return notes.firstOrNull;
  return notes.where((note) => note.id == id).firstOrNull;
});
