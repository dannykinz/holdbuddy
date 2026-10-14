import 'deadline.dart';
import 'deadline_category.dart';

abstract interface class DeadlineRepository {
  Future<List<Deadline>> fetchDeadlines();
  Future<Deadline> create({
    required String title,
    required DeadlineCategory category,
    required DateTime dueAt,
    required List<int> stops,
    required List<int> disabledStops,
  });
  Future<void> save(Deadline deadline);
}
