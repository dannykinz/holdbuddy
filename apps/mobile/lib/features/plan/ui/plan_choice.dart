import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_category.dart';
import '../../../core/widgets/hb_icon_tile.dart';
import '../../../core/widgets/hb_progress_bar.dart';
import '../domain/plan_status.dart';

import '../domain/study_plan.dart';

class PlanChoice extends StatelessWidget {
  const PlanChoice({
    super.key,
    required this.plan,
    required this.selected,
    required this.onPressed,
  });
  final StudyPlan plan;
  final bool selected;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.all(Tokens.space16),
      onTap: onPressed,
      leading: HbIconTile(
        asset: plan.status != PlanStatus.paused
            ? 'assets/icons/create_book.svg'
            : 'assets/icons/create_pen.svg',
        category: plan.status != PlanStatus.paused
            ? HbCategory.sky
            : HbCategory.purple,
      ),
      title: Text(plan.title, style: Tokens.strong),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Tokens.space8,
        children: [
          Text(
            plan.status == PlanStatus.paused
                ? l10n.planPausedCount(plan.unitsDone, plan.totalUnits)
                : l10n.previewTasks(plan.unitsDone, plan.totalUnits),
            style: Tokens.small,
          ),
          HbProgressBar(
            done: plan.unitsDone,
            thisWeek: 0,
            total: plan.totalUnits,
            label: plan.title,
          ),
        ],
      ),
      trailing: Icon(
        selected ? Icons.check_circle : Icons.radio_button_unchecked,
        color: selected
            ? AppColors.of(context).accent
            : AppColors.of(context).line,
      ),
    );
  }
}
