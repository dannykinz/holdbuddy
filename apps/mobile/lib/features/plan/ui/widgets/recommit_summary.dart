import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../domain/plan_change_kind.dart';
import '../../logic/plan_change_controller.dart';
import '../../logic/plan_controller.dart';
import 'change_schedule_copy.dart';

class RecommitSummary extends ConsumerWidget {
  const RecommitSummary({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final change = ref.watch(PlanChangeController.provider);
    final plan = change.plan;
    final l = AppLocalizations.of(context);
    final format = DateFormat('d MMMM', l.localeName);
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Tokens.radiusCard),
        side: BorderSide(color: AppColors.of(context).tintLine),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Tokens.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Tokens.space16,
          children: [
            Text(plan.title, style: Tokens.title),
            _muted(
              context,
              l.changeCovered(plan.unitsDone, plan.totalUnits - plan.unitsDone),
            ),
            const Divider(),
            Text(
              ChangeScheduleCopy.text(context, plan.contract),
              style: Tokens.strong,
            ),
            _muted(
              context,
              change.kind == PlanChangeKind.target
                  ? l.changeTargetSummary(
                      format.format(plan.targetDate),
                      format.format(change.projectedFinish),
                    )
                  : l.changeDuration(
                      plan.contract.duration.inMinutes,
                      format.format(change.projectedFinish),
                    ),
            ),
            const Divider(),
            Text(
              ref.watch(chosenPlanProvider).witnessIds.isEmpty
                  ? l.recommitPrivate
                  : l.recommitWitness,
              style: Tokens.strong,
            ),
            _muted(
              context,
              plan.contract.consequenceMessage ==
                      ref.watch(chosenPlanProvider).contract.consequenceMessage
                  ? l.recommitConsequence
                  : l.recommitMessageChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _muted(BuildContext context, String text) => Text(
    text,
    style: Tokens.body.copyWith(color: AppColors.of(context).muted),
  );
}
