import 'progress_period.dart';
import 'progress_snapshot.dart';

abstract interface class ProgressRepository {
  ProgressSnapshot snapshot(ProgressPeriod period);
}
