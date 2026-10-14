import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../plan/logic/current_chapter.dart';
import '../../../plan/logic/plan_controller.dart';
import 'tonight_shortcuts.dart';

class TonightCard extends ConsumerWidget {
  const TonightCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapter = ref.watch(currentChapterProvider);
    if (chapter == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DailyTokens.tonightRadius),
        side: BorderSide(color: colors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Tokens.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Tokens.space16,
          children: [
            _header(context, ref),
            _chapter(context, ref),
            const TonightShortcuts(),
            HbButton(
              label: l10n.startSession,
              onPressed: () => context.pushNamed(
                AppRoute.sessionChooseMode.name,
                extra: chapter.number,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: DailyTokens.copyGap,
            children: [
              Text(
                l10n.tonight,
                style: Tokens.label.copyWith(color: colors.orange),
              ),
              Text(
                l10n.previewStartsIn,
                style: Tokens.small.copyWith(color: colors.muted),
              ),
            ],
          ),
        ),
        _time(context, ref),
      ],
    );
  }

  Widget _time(BuildContext context, WidgetRef ref) {
    final time = ref.watch(chosenPlanProvider).contract.time;
    final date = ref.watch(chosenPlanProvider).startDate.add(time);
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: DateFormat('h:mm', l10n.localeName).format(date)),
          TextSpan(
            text: ' ${DateFormat('a', l10n.localeName).format(date)}',
            style: Tokens.strong,
          ),
        ],
      ),
      style: DailyTokens.time.copyWith(color: colors.text),
    );
  }

  Widget _chapter(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(chosenPlanProvider);
    final chapter = ref.watch(currentChapterProvider);
    if (chapter == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Tokens.space8,
      children: [
        Text(chapter.name, style: Tokens.title),
        Text(
          l10n.todayChapterSummary(
            chapter.number,
            plan.totalUnits,
            plan.title,
            plan.contract.duration.inMinutes,
          ),
          style: Tokens.small.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}
