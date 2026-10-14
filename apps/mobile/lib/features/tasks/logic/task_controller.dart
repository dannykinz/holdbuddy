import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../plan/logic/plan_controller.dart';
import '../domain/study_task.dart';
import '../domain/task_kind.dart';
import '../domain/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => throw StateError('TaskRepository must be bound at bootstrap.'),
);

final chapterTasksProvider = Provider.family<List<StudyTask>, int>((
  ref,
  chapter,
) {
  ref.watch(TaskController.provider);
  return ref
      .read(taskRepositoryProvider)
      .tasksFor(ref.watch(chosenPlanProvider).id, chapter);
});

class TaskController extends Notifier<List<StudyTask>> {
  static final provider = NotifierProvider<TaskController, List<StudyTask>>(
    TaskController.new,
  );
  @override
  List<StudyTask> build() => ref.read(taskRepositoryProvider).tasks;
  void toggle(StudyTask task) {
    ref.read(taskRepositoryProvider).save(task.copyWith(done: !task.done));
    state = ref.read(taskRepositoryProvider).tasks;
  }

  bool add(String value, {required int chapter}) {
    final title = value.trim();
    if (chapter < 1 || title.isEmpty || title.length > 160) return false;
    ref
        .read(taskRepositoryProvider)
        .save(
          StudyTask(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            kind: TaskKind.custom,
            planId: ref.read(chosenPlanProvider).id,
            chapter: chapter,
            title: title,
          ),
        );
    state = ref.read(taskRepositoryProvider).tasks;
    return true;
  }
}
