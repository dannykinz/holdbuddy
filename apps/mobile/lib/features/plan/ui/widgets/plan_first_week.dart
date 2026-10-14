import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_action_row.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_tab_scaffold.dart';
import '../../domain/plan_view.dart';
import '../../logic/plan_controller.dart';

class PlanFirstWeek extends ConsumerStatefulWidget {
  const PlanFirstWeek({super.key});
  @override
  ConsumerState<PlanFirstWeek> createState() => _PlanFirstWeekState();
}

class _PlanFirstWeekState extends ConsumerState<PlanFirstWeek> {
  bool _history = false;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chapters = ref.watch(planChaptersProvider(PlanView.firstWeek));
    final covered = ref.watch(chosenPlanProvider).unitsDone;
    final colors = AppColors.of(context);
    return HbTabScaffold(
      key: const ValueKey(AppRoute.plan),
      footer: HbButton(
        label: l10n.planRenegotiate,
        variant: HbButtonVariant.ghost,
        onPressed: () => context.pushNamed(AppRoute.renegotiate.name),
      ),
      children: [
        HbHeading(title: l10n.planWholeTitle),
        _summary(),
        Row(
          spacing: Tokens.space12,
          children: [
            Expanded(
              child: HbButton(
                label: l10n.planUpcoming,
                variant: _history
                    ? HbButtonVariant.ghost
                    : HbButtonVariant.secondary,
                onPressed: () => setState(() => _history = false),
              ),
            ),
            Expanded(
              child: HbButton(
                label: l10n.planHistory,
                variant: _history
                    ? HbButtonVariant.secondary
                    : HbButtonVariant.ghost,
                onPressed: () => setState(() => _history = true),
              ),
            ),
          ],
        ),
        for (final chapter
            in _history ? chapters.take(covered) : chapters.skip(covered))
          HbActionRow(
            title: '${chapter.number}. ${chapter.name}',
            subtitle: l10n.planChapterDate(
              DateFormat.MMMd(l10n.localeName).format(chapter.date),
            ),
            asset: 'assets/icons/daily_book.svg',
            color: colors.sky,
            fill: colors.skySoft,
            onPressed: () =>
                context.pushNamed(AppRoute.chapter.name, extra: chapter.number),
          ),
      ],
    );
  }

  Widget _summary() {
    final plan = ref.watch(chosenPlanProvider);
    final l10n = AppLocalizations.of(context);
    final finish = DateFormat.MMMMd(l10n.localeName).format(plan.targetDate);
    final progress = plan.totalUnits == 0
        ? 0.0
        : plan.unitsDone / plan.totalUnits;
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(Tokens.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Tokens.space16,
          children: [
            Text(plan.title, style: Tokens.title),
            Text(
              l10n.planCovered(plan.unitsDone, plan.totalUnits),
              style: Tokens.body,
            ),
            LinearProgressIndicator(value: progress),
            Text(l10n.planFinish(finish), style: Tokens.strong),
          ],
        ),
      ),
    );
  }
}
