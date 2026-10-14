import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_hero_tile.dart';
import '../../../core/widgets/hb_result_screen.dart';

class WitnessOfflineInviteScreen extends StatelessWidget {
  const WitnessOfflineInviteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = AppColors.of(context);
    return HbResultScreen(
      title: l.witnessOfflineHeading,
      body: l.witnessOfflineBody,
      leading: HbHeroTile(
        asset: 'assets/icons/auth_offline.svg',
        color: c.orange,
        fill: c.orangeSoft,
      ),
      actions: [
        HbButton(
          label: l.backPlan,
          onPressed: () => context.goNamed(AppRoute.plan.name),
        ),
      ],
    );
  }
}
