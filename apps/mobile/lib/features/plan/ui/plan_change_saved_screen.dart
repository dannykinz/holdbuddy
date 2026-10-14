import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_hero_tile.dart';
import '../../../core/widgets/hb_result_screen.dart';
import '../domain/plan_view.dart';
import '../logic/plan_controller.dart';

class PlanChangeSavedScreen extends ConsumerWidget {
  const PlanChangeSavedScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = AppColors.of(context);
    return HbResultScreen(
      title: l.planChanged,
      body: l.planChangedBody,
      showBack: false,
      leading: HbHeroTile(
        asset: 'assets/icons/auth_check.svg',
        color: c.green,
        fill: c.greenSoft,
      ),
      actions: [
        HbButton(
          label: l.seeUpdatedPlan,
          onPressed: () {
            ref.read(PlanController.provider.notifier).show(PlanView.path);
            context.goNamed(AppRoute.plan.name);
          },
        ),
      ],
    );
  }
}
