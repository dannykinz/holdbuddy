import '../../features/tasks/domain/study_task.dart';
import '../../features/tasks/domain/task_kind.dart';
import '../../features/tasks/domain/task_repository.dart';
import 'fake_seed_data.dart';

/// Each plan/chapter has an independent in-memory checklist preview.
class FakeTaskRepository implements TaskRepository {
  final _tasks = <StudyTask>[];
  @override
  List<StudyTask> get tasks => List.unmodifiable(_tasks);
  @override
  List<StudyTask> tasksFor(String planId, int chapter) {
    final existing = _tasks
        .where((task) => task.planId == planId && task.chapter == chapter)
        .toList();
    if (existing.isNotEmpty) return List.unmodifiable(existing);
    final defaults = [
      for (final kind in [TaskKind.read, TaskKind.examples, TaskKind.note])
        StudyTask(
          id: planId + ':' + chapter.toString() + ':' + kind.name,
          planId: planId,
          chapter: chapter,
          kind: kind,
          done:
              planId == FakeSeedData.planId &&
              chapter == 7 &&
              kind == TaskKind.read,
        ),
    ];
    _tasks.addAll(defaults);
    return List.unmodifiable(defaults);
  }

  @override
  void save(StudyTask task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index < 0) {
      _tasks.add(task);
      return;
    }
    _tasks[index] = task;
  }
}
