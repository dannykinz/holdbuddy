import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_progress_bar.dart';
import '../../domain/plan_change_kind.dart';
import '../../logic/plan_change_controller.dart';
import '../../logic/plan_controller.dart';
import 'change_schedule_copy.dart';

class UpdatedPlanSummary extends ConsumerWidget {
  const UpdatedPlanSummary({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final change = ref.watch(savedPlanChangeProvider);
    if (change == null) return const SizedBox.shrink();
    final plan = ref.watch(chosenPlanProvider);
    final l = AppLocalizations.of(context);
    final format = DateFormat('d MMMM', l.localeName);
    final rhythm = change.kind == PlanChangeKind.rhythm;
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(Tokens.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Tokens.space16,
          children: [
            Text(plan.title, style: Tokens.title),
            Text(
              rhythm
                  ? l.changeCovered(
                      plan.unitsDone,
                      plan.totalUnits - plan.unitsDone,
                    )
                  : change.kind == PlanChangeKind.target
                  ? l.updatedProjected(
                      plan.unitsDone,
                      plan.totalUnits,
                      format.format(change.projectedFinish),
                    )
                  : l.updatedCovered(plan.unitsDone, plan.totalUnits),
              style: Tokens.body.copyWith(color: AppColors.of(context).muted),
            ),
            if (rhythm)
              Text(
                ChangeScheduleCopy.text(context, plan.contract),
                style: Tokens.strong,
              )
            else
              HbProgressBar(
                done: plan.unitsDone,
                thisWeek: 0,
                total: plan.totalUnits,
                label: l.updatedCovered(plan.unitsDone, plan.totalUnits),
              ),
            Text(
              change.kind == PlanChangeKind.target
                  ? l.updatedTarget(format.format(plan.targetDate))
                  : rhythm
                  ? l.adjustNewFinish(format.format(change.projectedFinish))
                  : l.updatedFinish(format.format(change.projectedFinish)),
              style: rhythm
                  ? Tokens.body.copyWith(color: AppColors.of(context).muted)
                  : Tokens.strong,
            ),
          ],
        ),
      ),
    );
  }
}
