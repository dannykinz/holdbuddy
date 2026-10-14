import 'study_task.dart';

abstract interface class TaskRepository {
  List<StudyTask> get tasks;
  List<StudyTask> tasksFor(String planId, int chapter);
  void save(StudyTask task);
}
