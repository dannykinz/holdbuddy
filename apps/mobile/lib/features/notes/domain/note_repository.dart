import 'study_note.dart';

abstract interface class NoteRepository {
  List<StudyNote> get notes;
  StudyNote get draft;
  void save(StudyNote note);
  void remove(String id);
}
