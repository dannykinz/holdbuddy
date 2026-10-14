import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_avatar.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_result_screen.dart';
import '../logic/people_controller.dart';
import '../logic/people_failure.dart';
import 'witness_access_ended_screen.dart';

class WitnessInviteScreen extends ConsumerWidget {
  const WitnessInviteScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final peer = ref.watch(selectedPeerProvider);
    if (peer.blocked || peer.expired(DateTime.now()))
      return const WitnessAccessEndedScreen();
    return HbResultScreen(
      title: l.witnessInvitationHeading,
      body: l.witnessInvitationBody,
      leading: HbAvatar(
        image: AssetImage(peer.avatar),
        label: peer.name,
        size: PeopleTokens.heroAvatar,
        ringColor: AppColors.of(context).orange,
      ),
      details: [
        Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(Tokens.space20),
            child: Text(peer.planName, style: Tokens.strong),
          ),
        ),
        Text(l.witnessInvitationInfo),
        if (ref.watch(PeopleFailure.provider)) Text(l.safetyError),
      ],
      actions: [
        HbButton(
          label: l.witnessAcceptInvite,
          onPressed: () {
            if (ref.read(PeopleController.provider.notifier).accept(peer))
              context.goNamed(AppRoute.witnessAcknowledged.name);
          },
        ),
        HbButton(
          label: l.witnessDeclineInvite,
          variant: HbButtonVariant.ghost,
          onPressed: () {
            if (ref.read(PeopleController.provider.notifier).decline(peer))
              context.goNamed(AppRoute.witnessAccessEnded.name);
          },
        ),
      ],
    );
  }
}
