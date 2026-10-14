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
import '../../domain/plan_view.dart';
import '../../logic/plan_controller.dart';

class UpdatedPlanChapters extends ConsumerWidget {
  const UpdatedPlanChapters({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final plan = ref.watch(chosenPlanProvider);
    final history = ref.watch(PlanController.provider) == PlanView.history;
    final chapters = ref
        .watch(planChaptersProvider(PlanView.firstWeek))
        .where(
          (chapter) => history
              ? chapter.number <= plan.unitsDone
              : chapter.number > plan.unitsDone &&
                    chapter.number <= plan.totalUnits,
        );
    return Column(
      spacing: Tokens.space16,
      children: [
        _tabs(
          context,
          ref,
          history,
          plan.totalUnits - plan.unitsDone,
          plan.unitsDone,
        ),
        for (final chapter in chapters)
          HbActionRow(
            title: l.updatedChapterTitle(chapter.number, chapter.name),
            subtitle: l.updatedChapterDate(
              DateFormat('d MMM', l.localeName).format(chapter.date),
              TimeOfDay.fromDateTime(chapter.date).format(context),
              plan.contract.duration.inMinutes,
            ),
            asset: 'assets/icons/daily_book.svg',
            color: AppColors.of(context).sky,
            fill: AppColors.of(context).skySoft,
            onPressed: () =>
                context.pushNamed(AppRoute.chapter.name, extra: chapter.number),
          ),
      ],
    );
  }

  Widget _tabs(
    BuildContext context,
    WidgetRef ref,
    bool history,
    int upcoming,
    int done,
  ) {
    final l = AppLocalizations.of(context);
    final choices = [
      (l.updatedUpcoming, upcoming, PlanView.path),
      (l.updatedHistory, done, PlanView.history),
    ];
    return Row(
      spacing: Tokens.space12,
      children: [
        for (final (label, count, view) in choices)
          Expanded(
            child: HbButton(
              label: l.updatedTab(label, count),
              variant: (view == PlanView.history) == history
                  ? HbButtonVariant.secondary
                  : HbButtonVariant.ghost,
              onPressed: () =>
                  ref.read(PlanController.provider.notifier).show(view),
            ),
          ),
      ],
    );
  }
}
