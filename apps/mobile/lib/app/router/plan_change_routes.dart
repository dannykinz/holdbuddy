import 'package:flutter/widgets.dart';

import '../../features/plan/domain/plan_change_kind.dart';
import '../../features/plan/ui/adjust_plan_screen.dart';
import '../../features/plan/ui/archive_saved_screen.dart';
import '../../features/plan/ui/archive_screen.dart';
import '../../features/plan/ui/recommit_screen.dart';
import '../../features/plan/ui/renegotiate_screen.dart';
import 'app_route.dart';

abstract final class PlanChangeRoutes {
  static Widget? screen(AppRoute route) => switch (route) {
    AppRoute.renegotiate => const RenegotiateScreen(),
    AppRoute.adjustRhythm => const AdjustPlanScreen(
      kind: PlanChangeKind.rhythm,
    ),
    AppRoute.adjustScope => const AdjustPlanScreen(kind: PlanChangeKind.scope),
    AppRoute.adjustTargetDate => const AdjustPlanScreen(
      kind: PlanChangeKind.target,
    ),
    AppRoute.adjustOther => const AdjustPlanScreen(kind: PlanChangeKind.other),
    AppRoute.recommit => const RecommitScreen(),
    AppRoute.archiveConfirm => const ArchiveScreen(),
    AppRoute.archiveSaved => const ArchiveSavedScreen(),
    _ => null,
  };
}
