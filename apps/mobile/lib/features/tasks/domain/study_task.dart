import 'task_kind.dart';

class StudyTask {
  const StudyTask({
    required this.id,
    required this.kind,
    this.title = '',
    this.done = false,
    this.planId = '',
    this.chapter = 1,
  });
  final String id;
  final TaskKind kind;
  final String title;
  final bool done;
  final String planId;
  final int chapter;
  StudyTask copyWith({bool? done}) => StudyTask(
    id: id,
    kind: kind,
    title: title,
    done: done ?? this.done,
    planId: planId,
    chapter: chapter,
  );
}
