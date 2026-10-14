import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_hero_tile.dart';
import '../../../core/widgets/hb_result_screen.dart';

class WitnessAcknowledgedScreen extends StatelessWidget {
  const WitnessAcknowledgedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = AppColors.of(context);
    return HbResultScreen(
      title: l.witnessAckHeading,
      body: l.witnessAckBody,
      leading: HbHeroTile(
        asset: 'assets/icons/auth_check.svg',
        color: c.green,
        fill: c.greenSoft,
      ),
      actions: [
        HbButton(
          label: l.witnessViewPlan,
          onPressed: () => context.goNamed(AppRoute.partnerTheirPlan.name),
        ),
      ],
    );
  }
}
