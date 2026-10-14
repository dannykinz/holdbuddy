import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_hero_tile.dart';
import '../../../core/widgets/hb_person_row.dart';
import '../../../core/widgets/hb_result_screen.dart';
import '../../../core/widgets/hb_sheet.dart';
import '../logic/people_controller.dart';
import '../logic/people_failure.dart';
import 'witness_access_ended_screen.dart';
import 'witness_contact_sheet.dart';

class WitnessPendingScreen extends ConsumerWidget {
  const WitnessPendingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final peer = ref.watch(selectedPeerProvider);
    if (peer.expired(DateTime.now())) return const WitnessAccessEndedScreen();
    return HbResultScreen(
      title: l.witnessPendingHeading,
      body: l.witnessPendingBody,
      leading: HbHeroTile(
        asset: 'assets/icons/auth_mail.svg',
        color: c.sky,
        fill: c.skySoft,
      ),
      details: [
        Card.outlined(
          child: HbPersonRow(
            name: peer.contact,
            subtitle: l.witnessWaiting,
            avatar: peer.avatar,
            trailing: const SizedBox.shrink(),
          ),
        ),
        Text(l.witnessWaitBody),
        if (ref.watch(PeopleFailure.provider)) Text(l.safetyError),
      ],
      actions: [
        HbButton(
          label: peer.reminded ? l.witnessReminded : l.witnessResend,
          variant: HbButtonVariant.secondary,
          onPressed: peer.reminded
              ? null
              : () => ref.read(PeopleController.provider.notifier).remind(peer),
        ),
        HbButton(
          label: l.witnessChangeContact,
          variant: HbButtonVariant.ghost,
          onPressed: () => HbSheet.show<void>(
            context: context,
            title: l.witnessChangeContact,
            child: const WitnessContactSheet(editing: true),
          ),
        ),
      ],
    );
  }
}
