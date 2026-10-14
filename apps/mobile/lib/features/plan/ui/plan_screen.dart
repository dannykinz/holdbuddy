import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_tab_scaffold.dart';
import '../../today/domain/today_view.dart';
import '../../today/logic/today_controller.dart';
import '../domain/plan_status.dart';
import '../domain/plan_view.dart';
import '../logic/plan_change_controller.dart';
import '../logic/plan_controller.dart';
import 'archive_saved_screen.dart';
import 'plan_change_saved_screen.dart';
import 'widgets/plan_first_week.dart';
import 'widgets/plan_header.dart';
import 'widgets/plan_load_error.dart';
import 'widgets/plan_path.dart';
import 'widgets/plan_totals.dart';
import 'widgets/updated_plan_content.dart';

class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(chosenPlanProvider);
    final selectedView = ref.watch(PlanController.provider);
    final view = plan.unitsDone >= plan.totalUnits && plan.totalUnits > 0
        ? PlanView.complete
        : selectedView;
    final today = ref.watch(TodayController.provider);
    if (view == PlanView.updated) return const PlanChangeSavedScreen();
    if (plan.status == PlanStatus.archived) return const ArchiveSavedScreen();
    if (view != PlanView.complete && ref.watch(savedPlanChangeProvider) != null)
      return const UpdatedPlanContent();
    if (view == PlanView.loadError) return const PlanLoadError();
    if (view != PlanView.complete &&
        (today == TodayView.first || today == TodayView.firstDone))
      return const PlanFirstWeek();
    return HbTabScaffold(
      key: const ValueKey(AppRoute.plan),
      topBar: const PlanHeader(),
      children: [
        PlanTotals(complete: view == PlanView.complete),
        if (view == PlanView.complete)
          HbButton(
            label: AppLocalizations.of(context).planStartAnother,
            onPressed: () => context.pushNamed(AppRoute.scope.name),
          ),
        PlanPath(view: view),
      ],
    );
  }
}
