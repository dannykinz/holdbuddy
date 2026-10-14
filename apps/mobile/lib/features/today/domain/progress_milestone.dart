import 'milestone_kind.dart';

class ProgressMilestone {
  const ProgressMilestone({
    required this.kind,
    required this.done,
    required this.total,
  });
  final MilestoneKind kind;
  final int done;
  final int total;
  bool get complete => done >= total;
}
