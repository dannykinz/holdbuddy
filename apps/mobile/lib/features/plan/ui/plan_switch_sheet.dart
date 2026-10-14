import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../today/domain/today_view.dart';
import '../../today/logic/today_controller.dart';
import '../domain/plan_view.dart';
import '../logic/chosen_plan.dart';
import '../logic/plan_controller.dart';
import 'plan_choice.dart';

class PlanSwitchSheet extends ConsumerWidget {
  const PlanSwitchSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(planChoicesProvider);
    final chosen = ref.watch(chosenPlanProvider);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space12,
      children: [
        Card(
          color: AppColors.of(context).soft,
          child: Column(
            children: [
              for (var index = 0; index < plans.length; index++) ...[
                if (index > 0)
                  const Divider(
                    indent: Tokens.space16,
                    endIndent: Tokens.space16,
                  ),
                PlanChoice(
                  plan: plans[index],
                  selected: plans[index].id == chosen.id,
                  onPressed: () {
                    if (plans[index].id != chosen.id) {
                      ref
                          .read(ChosenPlan.provider.notifier)
                          .select(plans[index].id);
                      ref
                          .read(PlanController.provider.notifier)
                          .show(PlanView.path);
                      ref
                          .read(TodayController.provider.notifier)
                          .show(
                            plans[index].unitsDone == 0
                                ? TodayView.first
                                : TodayView.ready,
                          );
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ],
          ),
        ),
        HbButton(
          label: l10n.planStartNew,
          variant: HbButtonVariant.secondary,
          onPressed: () {
            Navigator.pop(context);
            unawaited(context.pushNamed<void>(AppRoute.scope.name));
          },
        ),
      ],
    );
  }
}
