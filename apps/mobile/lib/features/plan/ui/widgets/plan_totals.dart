import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_category.dart';
import '../../../../core/widgets/hb_chip.dart';
import '../../../../core/widgets/hb_progress_bar.dart';
import '../../../today/logic/today_controller.dart';
import '../../logic/plan_controller.dart';

class PlanTotals extends ConsumerWidget {
  const PlanTotals({super.key, this.complete = false});
  final bool complete;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(chosenPlanProvider);
    final l10n = AppLocalizations.of(context);
    final count = complete ? plan.totalUnits : plan.unitsDone;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space16,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: Tokens.space12,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: count.toString(),
                    style: DailyTokens.dayNumber,
                  ),
                  TextSpan(
                    text: ' ${l10n.previewChapters(plan.totalUnits)}',
                    style: Tokens.label,
                  ),
                ],
              ),
            ),
            HbChip(
              label: complete
                  ? l10n.planFinished
                  : DateFormat.MMMd(l10n.localeName).format(plan.targetDate),
              category: complete ? HbCategory.green : HbCategory.orange,
            ),
          ],
        ),
        HbProgressBar(
          done: count,
          thisWeek: complete ? 0 : ref.watch(todayOverviewProvider).weekUnits,
          total: plan.totalUnits,
          label: l10n.previewTasks(count, plan.totalUnits),
        ),
      ],
    );
  }
}
