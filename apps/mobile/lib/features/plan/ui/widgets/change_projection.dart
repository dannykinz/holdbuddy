import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_notice.dart';
import '../../domain/plan_change_kind.dart';
import '../../logic/plan_change_controller.dart';

class ChangeProjection extends ConsumerWidget {
  const ChangeProjection({super.key, required this.kind});
  final PlanChangeKind kind;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final change = ref.watch(PlanChangeController.provider);
    final l = AppLocalizations.of(context);
    final date = DateFormat(
      'd MMMM',
      l.localeName,
    ).format(change.projectedFinish);
    return HbNotice(
      title: kind == PlanChangeKind.target
          ? l.adjustPace
          : l.adjustNewFinish(date),
      body: kind == PlanChangeKind.target
          ? l.changeTargetPace(change.plan.contract.days.length, date)
          : l.adjustRemaining(
              change.plan.totalUnits - change.plan.unitsDone,
              change.plan.contract.days.length,
            ),
    );
  }
}
