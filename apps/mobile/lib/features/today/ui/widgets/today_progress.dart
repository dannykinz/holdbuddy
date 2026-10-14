import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_progress_bar.dart';
import '../../../../core/widgets/hb_section_heading.dart';
import '../../../notes/logic/note_controller.dart';
import '../../../plan/logic/plan_change_controller.dart';
import '../../../plan/logic/plan_controller.dart';
import '../../logic/today_controller.dart';

class TodayProgress extends ConsumerWidget {
  const TodayProgress({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(todayOverviewProvider);
    final change = ref.watch(savedPlanChangeProvider);
    final plan = ref.watch(chosenPlanProvider);
    final total = plan.totalUnits;
    final done = plan.unitsDone;
    final finish = change?.projectedFinish ?? data.finishDate;
    final name = change?.plan.title ?? data.planName;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space12,
      children: [
        HbSectionHeading(
          title: l10n.previewOnPace(name),
          action: l10n.progress,
          onPressed: () => context.pushNamed(AppRoute.progress.name),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: Tokens.space8,
          children: [
            Text(done.toString(), style: Tokens.timer),
            Text(
              l10n.previewChapters(total),
              style: Tokens.strong.copyWith(
                color: AppColors.of(context).subtle,
              ),
            ),
          ],
        ),
        HbProgressBar(
          done: done,
          thisWeek: data.weekUnits,
          total: total,
          label: l10n.previewTasks(done, total),
        ),
        Wrap(
          spacing: DailyTokens.statGap,
          runSpacing: Tokens.space8,
          children: [
            _stat(
              context,
              'flag',
              DateFormat.MMMd(l10n.localeName).format(finish),
            ),
            _stat(context, 'clock', l10n.previewStudied(data.studyHours)),
            _stat(
              context,
              'pen',
              l10n.previewNotes(ref.watch(NoteController.provider).length),
            ),
          ],
        ),
      ],
    );
  }

  Widget _stat(BuildContext context, String icon, String text) => Row(
    mainAxisSize: MainAxisSize.min,
    spacing: DailyTokens.dateGap,
    children: [
      SvgPicture.asset(
        'assets/icons/daily_$icon.svg',
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(
          AppColors.of(context).subtle,
          BlendMode.srcIn,
        ),
      ),
      Text(text, style: Tokens.label),
    ],
  );
}
