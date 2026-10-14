import '../../features/deadlines/domain/deadline.dart';
import '../../features/deadlines/domain/deadline_category.dart';
import '../../features/deadlines/domain/deadline_repository.dart';
import '../../features/deadlines/domain/deadline_schedule.dart';
import '../../features/deadlines/domain/deadline_status.dart';

/// In-memory UI fake. No persistence, sync or notification scheduling.
class FakeDeadlineRepository implements DeadlineRepository {
  FakeDeadlineRepository(List<Deadline> deadlines, {DateTime? today})
    : _deadlines = deadlines
          .map(
            (deadline) => deadline.copyWith(
              stops: DeadlineSchedule.offsets(
                deadline.dueAt,
                today ?? DateTime.now(),
              ),
            ),
          )
          .toList();
  final List<Deadline> _deadlines;
  int _sequence = 0;
  @override
  Future<List<Deadline>> fetchDeadlines() async =>
      List.unmodifiable(_deadlines);
  @override
  Future<void> save(Deadline deadline) async {
    final index = _deadlines.indexWhere((item) => item.id == deadline.id);
    if (index < 0) throw StateError('Reminder no longer exists.');
    _deadlines[index] = deadline;
  }

  @override
  Future<Deadline> create({
    required String title,
    required DeadlineCategory category,
    required DateTime dueAt,
    required List<int> stops,
    required List<int> disabledStops,
  }) async {
    final deadline = Deadline(
      id: 'fake-deadline-' + (++_sequence).toString(),
      userId: _deadlines.isEmpty ? 'fake-learner' : _deadlines.first.userId,
      title: title,
      category: category,
      dueAt: dueAt,
      status: DeadlineStatus.upcoming,
      stops: stops,
      disabledStops: disabledStops,
    );
    _deadlines.add(deadline);
    return deadline;
  }
}
