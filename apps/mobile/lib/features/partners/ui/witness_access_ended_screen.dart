import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_hero_tile.dart';
import '../../../core/widgets/hb_result_screen.dart';
import '../logic/people_controller.dart';

class WitnessAccessEndedScreen extends ConsumerWidget {
  const WitnessAccessEndedScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final peer = ref.watch(selectedPeerProvider);
    return HbResultScreen(
      title: peer.declined || peer.expired(DateTime.now())
          ? l.peopleInviteFailed
          : l.witnessEndedHeading,
      body: l.witnessEndedBody,
      leading: HbHeroTile(
        asset: 'assets/icons/auth_lock.svg',
        color: c.green,
        fill: c.greenSoft,
      ),
      actions: [
        HbButton(
          label: l.safetyBackPartners,
          onPressed: () => context.goNamed(AppRoute.partners.name),
        ),
      ],
    );
  }
}
