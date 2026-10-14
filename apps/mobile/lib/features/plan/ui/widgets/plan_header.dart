import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_sheet.dart';
import '../../domain/plan_view.dart';
import '../../logic/plan_controller.dart';
import '../plan_switch_sheet.dart';

class PlanHeader extends ConsumerWidget {
  const PlanHeader({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(chosenPlanProvider);
    return Row(
      spacing: Tokens.space12,
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => HbSheet.show<void>(
              context: context,
              title: AppLocalizations.of(context).planYourPlans,
              child: const PlanSwitchSheet(),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            child: Row(
              spacing: Tokens.space8,
              children: [
                Flexible(
                  child: Text(
                    plan.title,
                    style: PlanTokens.heading.copyWith(
                      color: AppColors.of(context).text,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/daily_down.svg',
                  excludeFromSemantics: true,
                  colorFilter: ColorFilter.mode(
                    AppColors.of(context).subtle,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton.filledTonal(
          tooltip: AppLocalizations.of(context).planOptions,
          onPressed: () => _options(context, ref),
          icon: SvgPicture.asset(
            'assets/icons/plan_more.svg',
            excludeFromSemantics: true,
            colorFilter: ColorFilter.mode(
              AppColors.of(context).text,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _options(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return HbSheet.show<void>(
      context: context,
      title: l10n.planOptions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: () => _view(context, ref, PlanView.path),
            child: Text(l10n.planUpcoming),
          ),
          TextButton(
            onPressed: () => _view(context, ref, PlanView.history),
            child: Text(l10n.planHistory),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              unawaited(context.pushNamed<void>(AppRoute.renegotiate.name));
            },
            child: Text(l10n.planRenegotiate),
          ),
        ],
      ),
    );
  }

  void _view(BuildContext context, WidgetRef ref, PlanView view) {
    ref.read(PlanController.provider.notifier).show(view);
    Navigator.pop(context);
  }
}
