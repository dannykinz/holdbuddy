import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/progress_period.dart';
import '../domain/progress_repository.dart';
import '../domain/progress_snapshot.dart';

final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => throw StateError('ProgressRepository must be bound at bootstrap.'),
);
final progressSnapshotProvider = Provider<ProgressSnapshot>(
  (ref) => ref
      .watch(progressRepositoryProvider)
      .snapshot(ref.watch(ProgressController.provider)),
);

class ProgressController extends Notifier<ProgressPeriod> {
  static final provider = NotifierProvider<ProgressController, ProgressPeriod>(
    ProgressController.new,
  );
  @override
  ProgressPeriod build() => ProgressPeriod.week;
  void select(int index) => state = ProgressPeriod.values[index];
}
