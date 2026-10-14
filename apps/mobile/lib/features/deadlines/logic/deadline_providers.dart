import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/deadline.dart';
import '../domain/deadline_repository.dart';
import '../domain/deadline_status.dart';

final deadlineRepositoryProvider = Provider<DeadlineRepository>(
  (ref) => throw StateError('DeadlineRepository must be bound at bootstrap.'),
);
final deadlinesProvider = FutureProvider<List<Deadline>>(
  (ref) => ref.watch(deadlineRepositoryProvider).fetchDeadlines(),
);
final nearestDeadlineProvider = Provider<Deadline?>((ref) {
  final upcoming =
      (ref.watch(deadlinesProvider).asData?.value ?? <Deadline>[])
          .where((deadline) => deadline.status == DeadlineStatus.upcoming)
          .toList()
        ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
  return upcoming.isEmpty ? null : upcoming.first;
});
