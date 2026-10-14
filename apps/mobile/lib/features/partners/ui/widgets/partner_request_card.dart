import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_person_row.dart';
import '../../domain/peer.dart';
import '../../logic/people_controller.dart';
import '../../logic/selected_peer.dart';

class PartnerRequestCard extends ConsumerWidget {
  const PartnerRequestCard({super.key, required this.peer});
  final Peer peer;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Card.outlined(
      child: Column(
        children: [
          HbPersonRow(
            name: l.peopleRequest(peer.name),
            subtitle: peer.planName,
            avatar: peer.avatar,
            trailing: const SizedBox.shrink(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Tokens.space16,
              0,
              Tokens.space16,
              Tokens.space16,
            ),
            child: Row(
              spacing: Tokens.space12,
              children: [
                Expanded(
                  child: HbButton(
                    label: l.peopleAccept,
                    onPressed: () => _accept(context, ref),
                  ),
                ),
                Expanded(
                  child: HbButton(
                    label: l.peopleDecline,
                    variant: HbButtonVariant.secondary,
                    onPressed: () {
                      if (ref
                          .read(PeopleController.provider.notifier)
                          .decline(peer))
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l.peopleInviteFailed)),
                        );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _accept(BuildContext context, WidgetRef ref) {
    if (!ref.read(PeopleController.provider.notifier).accept(peer)) return;
    ref.read(SelectedPeer.provider.notifier).select(peer.id);
    unawaited(context.pushNamed<void>(AppRoute.witnessAcknowledged.name));
  }
}
