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
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_person_row.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../../../core/widgets/hb_sheet.dart';
import '../domain/peer.dart';
import '../logic/people_controller.dart';
import '../logic/people_failure.dart';
import '../logic/selected_peer.dart';
import 'widgets/partner_request_card.dart';
import 'witness_contact_sheet.dart';

class PartnersScreen extends ConsumerWidget {
  const PartnersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final peers = ref
        .watch(PeopleController.provider)
        .where((peer) => !peer.blocked)
        .toList();
    final requests = peers
        .where((peer) => peer.request && !peer.expired(DateTime.now()))
        .toList();
    return HbPageScaffold(
      topBar: const HbPageHeader(fallback: AppRoute.settings),
      content: [
        HbHeading(title: l.peopleTitle, description: l.peopleBody),
        if (requests.isNotEmpty) ...[
          _label(context, l.peopleRequests, true),
          for (final peer in requests) PartnerRequestCard(peer: peer),
        ],
        _label(context, l.peopleHoldingYou, false),
        _group(
          context,
          ref,
          peers.where((peer) => peer.holdsMe || peer.pending).toList(),
          true,
        ),
        _label(context, l.peopleYouHold, false),
        _group(context, ref, peers.where((peer) => peer.iHold).toList(), false),
        if (ref.watch(PeopleFailure.provider)) Text(l.safetyError),
      ],
      actions: [
        HbButton(
          label: l.peopleInvite,
          variant: HbButtonVariant.secondary,
          onPressed: () => HbSheet.show<void>(
            context: context,
            title: l.peopleInvite,
            child: const WitnessContactSheet(),
          ),
        ),
      ],
      footnote: const HbPreviewNote(),
    );
  }

  Widget _label(BuildContext context, String text, bool requests) => Text(
    text,
    style: Tokens.dataLabel.copyWith(
      color: requests
          ? AppColors.of(context).pink
          : AppColors.of(context).subtle,
    ),
  );
  Widget _group(
    BuildContext context,
    WidgetRef ref,
    List<Peer> peers,
    bool holdingMe,
  ) {
    final l = AppLocalizations.of(context);
    if (peers.isEmpty) return Text(l.peopleNoPartners, style: Tokens.small);
    return Card.outlined(
      child: Column(
        children: [
          for (var index = 0; index < peers.length; index++) ...[
            if (index > 0)
              const Divider(indent: Tokens.space16, endIndent: Tokens.space16),
            _person(context, ref, peers[index], holdingMe),
          ],
        ],
      ),
    );
  }

  void _open(BuildContext context, WidgetRef ref, Peer peer, bool holdingMe) {
    ref.read(SelectedPeer.provider.notifier).select(peer.id);
    unawaited(
      context.pushNamed<void>(
        holdingMe
            ? peer.pending
                  ? AppRoute.witnessPending.name
                  : AppRoute.witnessManage.name
            : AppRoute.partnerTheirPlan.name,
      ),
    );
  }

  Widget _person(
    BuildContext context,
    WidgetRef ref,
    Peer peer,
    bool holdingMe,
  ) {
    final l = AppLocalizations.of(context);
    return HbPersonRow(
      name: peer.name,
      avatar: peer.avatar,
      subtitle: _subtitle(context, ref, peer, holdingMe),
      trailing: holdingMe && peer.iHold
          ? Text(
              l.peopleMutual,
              style: Tokens.meta.copyWith(color: AppColors.of(context).green),
            )
          : null,
      onPressed: () => _open(context, ref, peer, holdingMe),
    );
  }

  String _subtitle(
    BuildContext context,
    WidgetRef ref,
    Peer peer,
    bool holdingMe,
  ) {
    final l = AppLocalizations.of(context);
    if (!holdingMe)
      return l.peoplePlanStatus(
        peer.planName,
        peer.sessionHappened
            ? l.peopleOnPace
            : peer.sessionMissed
            ? l.peopleMissed
            : l.peopleNoSession,
      );
    if (peer.pending) return l.witnessWaiting;
    if (peer.planName.isEmpty) return l.peopleLink;
    return l.peopleSees(peer.sharedPlanName);
  }
}
