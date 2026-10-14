import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_progress_bar.dart';
import '../../domain/milestone_kind.dart';
import '../../domain/progress_milestone.dart';

class MilestoneCard extends StatelessWidget {
  const MilestoneCard({super.key, required this.item});
  final ProgressMilestone item;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (title, body, icon) = _labels(l10n);
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(Tokens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Tokens.space12,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/progress_$icon.svg',
                  excludeFromSemantics: true,
                  colorFilter: ColorFilter.mode(switch (item.kind) {
                    MilestoneKind.comeback => AppColors.of(context).green,
                    MilestoneKind.halfway => AppColors.of(context).sky,
                    MilestoneKind.notes => AppColors.of(context).purple,
                    MilestoneKind.finish => AppColors.of(context).orange,
                  }, BlendMode.srcIn),
                ),
                const Spacer(),
                Text(
                  item.complete ? l10n.dayDone : '${item.done}/${item.total}',
                  style: Tokens.meta,
                ),
              ],
            ),
            Text(title, style: Tokens.strong),
            Text(
              body,
              style: Tokens.small.copyWith(color: AppColors.of(context).muted),
            ),
            if (!item.complete)
              HbProgressBar(
                done: item.done,
                thisWeek: 0,
                total: item.total,
                label: title,
              ),
          ],
        ),
      ),
    );
  }

  (String, String, String) _labels(AppLocalizations l10n) {
    return switch (item.kind) {
      MilestoneKind.comeback => (
        l10n.progressFirstComeback,
        l10n.progressReturn,
        'refresh',
      ),
      MilestoneKind.halfway => (
        l10n.progressHalfway,
        l10n.progressHalfwayBody,
        'book',
      ),
      MilestoneKind.notes => (
        l10n.progressTenNotes,
        l10n.progressOwnWords,
        'pen',
      ),
      MilestoneKind.finish => (
        l10n.progressFinishLine,
        l10n.progressAllChapters,
        'flag',
      ),
    };
  }
}
