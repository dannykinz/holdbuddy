import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_hero_tile.dart';
import '../../../core/widgets/hb_result_screen.dart';
import '../../../core/widgets/hb_sheet.dart';
import 'witness_contact_sheet.dart';

class WitnessRemovedScreen extends StatelessWidget {
  const WitnessRemovedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = AppColors.of(context);
    return HbResultScreen(
      title: l.witnessManagePrivate,
      body: l.witnessRemovedBody,
      leading: HbHeroTile(
        asset: 'assets/icons/auth_lock.svg',
        color: c.green,
        fill: c.greenSoft,
      ),
      actions: [
        HbButton(
          label: l.witnessInviteElse,
          onPressed: () => HbSheet.show<void>(
            context: context,
            title: l.peopleInvite,
            child: const WitnessContactSheet(),
          ),
        ),
        HbButton(
          label: l.backSettings,
          variant: HbButtonVariant.secondary,
          onPressed: () => context.goNamed(AppRoute.settings.name),
        ),
      ],
    );
  }
}
