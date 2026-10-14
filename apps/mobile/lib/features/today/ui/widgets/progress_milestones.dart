import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../logic/progress_controller.dart';
import 'milestone_card.dart';

class ProgressMilestones extends ConsumerWidget {
  const ProgressMilestones({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final milestones = ref.watch(progressSnapshotProvider).milestones;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space20,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.progressMilestones, style: Tokens.strong),
            ),
            Text(
              l10n.previewTasks(
                milestones.where((item) => item.complete).length,
                milestones.length,
              ),
              style: Tokens.meta,
            ),
          ],
        ),
        Wrap(
          spacing: Tokens.space12,
          runSpacing: Tokens.space12,
          children: [
            for (final item in milestones)
              SizedBox(
                width: ProgressTokens.milestoneWidth,
                child: MilestoneCard(item: item),
              ),
          ],
        ),
      ],
    );
  }
}
