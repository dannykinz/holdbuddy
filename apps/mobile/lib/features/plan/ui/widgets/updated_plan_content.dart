import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_action_row.dart';
import '../../../../core/widgets/hb_avatar.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_tab_scaffold.dart';
import '../../domain/plan_change_kind.dart';
import '../../domain/plan_view.dart';
import '../../logic/plan_change_controller.dart';
import '../../logic/plan_controller.dart';
import 'updated_plan_chapters.dart';
import 'updated_plan_summary.dart';

class UpdatedPlanContent extends ConsumerWidget {
  const UpdatedPlanContent({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final change = ref.watch(savedPlanChangeProvider);
    if (change == null) return const SizedBox.shrink();
    final rhythm = change.kind == PlanChangeKind.rhythm;
    return HbTabScaffold(
      topBar: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          tooltip: l.todayProfile,
          onPressed: () => context.pushNamed(AppRoute.profileEdit.name),
          icon: HbAvatar(
            image: const AssetImage('assets/avatars/people_you.png'),
            label: l.todayProfile,
            ringColor: AppColors.of(context).orange,
          ),
        ),
      ),
      children: [
        HbHeading(title: rhythm ? l.planFits : l.planWhole),
        const UpdatedPlanSummary(),
        if (rhythm) _next(context, ref) else const UpdatedPlanChapters(),
        HbButton(
          label: l.planRenegotiate,
          variant: HbButtonVariant.ghost,
          onPressed: () => context.pushNamed(AppRoute.renegotiate.name),
        ),
      ],
    );
  }

  Widget _next(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final plan = ref.watch(chosenPlanProvider);
    final chapter = ref
        .watch(planChaptersProvider(PlanView.firstWeek))
        .where((chapter) => chapter.number > plan.unitsDone)
        .firstOrNull;
    if (chapter == null) return const SizedBox.shrink();
    return HbActionRow(
      title: l.updatedNext(
        DateFormat('EEE, d MMM', l.localeName).format(chapter.date),
      ),
      subtitle: l.updatedChapter(chapter.number, chapter.name),
      asset: 'assets/icons/daily_book.svg',
      color: AppColors.of(context).sky,
      fill: AppColors.of(context).skySoft,
      onPressed: () =>
          context.pushNamed(AppRoute.chapter.name, extra: chapter.number),
    );
  }
}
