import 'note_category.dart';

class StudyNote {
  const StudyNote({
    required this.id,
    required this.chapter,
    required this.chapterName,
    required this.body,
    required this.createdAt,
    this.recallQuestion = '',
    this.planId = '',
    this.category = NoteCategory.purple,
  });
  final NoteCategory category;
  final String id;
  final String planId;
  final int chapter;
  final String chapterName;
  final String body;
  final String recallQuestion;
  final DateTime createdAt;

  StudyNote copyWith({
    NoteCategory? category,
    String? id,
    String? planId,
    int? chapter,
    String? chapterName,
    String? body,
    DateTime? createdAt,
  }) => StudyNote(
    category: category ?? this.category,
    id: id ?? this.id,
    planId: planId ?? this.planId,
    chapter: chapter ?? this.chapter,
    chapterName: chapterName ?? this.chapterName,
    body: body ?? this.body,
    recallQuestion: recallQuestion,
    createdAt: createdAt ?? this.createdAt,
  );
}
