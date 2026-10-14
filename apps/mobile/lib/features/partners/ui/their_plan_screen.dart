import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_avatar.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../logic/people_controller.dart';
import '../logic/people_failure.dart';
import 'widgets/peer_session_week.dart';
import 'witness_access_ended_screen.dart';

class TheirPlanScreen extends ConsumerWidget {
  const TheirPlanScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peer = ref.watch(selectedPeerProvider);
    final l = AppLocalizations.of(context);
    if (peer.blocked || !peer.iHold) return const WitnessAccessEndedScreen();
    return HbPageScaffold(
      topBar: HbPageHeader(
        fallback: AppRoute.partners,
        trailing: IconButton.filledTonal(
          tooltip: l.peopleOptions,
          onPressed: () => context.pushNamed(AppRoute.safetyOptions.name),
          icon: const Icon(Icons.more_horiz),
        ),
      ),
      content: [
        Row(
          spacing: Tokens.space16,
          children: [
            HbAvatar(
              image: AssetImage(peer.avatar),
              label: peer.name,
              size: Tokens.buttonHeight,
            ),
            Expanded(
              child: HbHeading(title: peer.name, description: peer.planName),
            ),
          ],
        ),
        HbHeading(
          title: l.peopleSessionWeek,
          description: peer.sessionHappened
              ? l.peopleOnPace
              : peer.sessionMissed
              ? l.peopleMissed
              : l.peopleNoSession,
        ),
        const PeerSessionWeek(),
        _message(context, peer.message),
        Text(
          l.peoplePrivate,
          style: Tokens.small.copyWith(color: AppColors.of(context).muted),
        ),
        TextButton(
          onPressed: () => context.pushNamed(AppRoute.witnessStopSharing.name),
          child: Text(l.witnessStop),
        ),
        if (ref.watch(PeopleFailure.provider)) Text(l.safetyError),
      ],
      actions: [
        HbButton(
          label: l.peopleSendNudge,
          onPressed: () {
            if (ref.read(PeopleController.provider.notifier).nudge(peer))
              unawaited(
                context.pushNamed<void>(AppRoute.witnessNudgeSent.name),
              );
          },
        ),
      ],
      footnote: const HbPreviewNote(),
    );
  }

  Widget _message(BuildContext context, String message) {
    final c = AppColors.of(context);
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(Tokens.space16),
      decoration: BoxDecoration(
        color: c.orangeSoft,
        borderRadius: BorderRadius.circular(Tokens.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Tokens.space8,
        children: [
          Text(
            l.peopleMessageLabel,
            style: Tokens.dataLabel.copyWith(color: c.orange),
          ),
          Text(
            message.isEmpty ? l.peopleNoMessage : message,
            style: Tokens.body,
          ),
        ],
      ),
    );
  }
}
