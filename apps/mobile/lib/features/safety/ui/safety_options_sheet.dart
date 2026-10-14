import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_action_row.dart';
import '../../../core/widgets/hb_person_row.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../../partners/logic/people_controller.dart';
import '../../partners/logic/people_failure.dart';

class SafetyOptionsSheet extends ConsumerWidget {
  const SafetyOptionsSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final peer = ref.watch(selectedPeerProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Tokens.space12,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HbPersonRow(
          name: peer.name,
          subtitle: l.peoplePrivate,
          avatar: peer.avatar,
          trailing: const SizedBox.shrink(),
        ),
        if (!peer.blocked) ...[
          HbActionRow(
            title: peer.muted ? l.safetyUnmute : l.safetyMute,
            subtitle: l.safetyMuteBody,
            asset: 'assets/icons/people_mute.svg',
            color: c.sky,
            fill: c.skySoft,
            selected: peer.muted,
            onPressed: () => ref
                .read(PeopleController.provider.notifier)
                .save(peer.copyWith(muted: !peer.muted)),
          ),
          HbActionRow(
            title: l.safetyBlockName(peer.name),
            subtitle: l.safetyBlockBody,
            asset: 'assets/icons/people_block.svg',
            color: c.orange,
            fill: c.orangeSoft,
            onPressed: () => _open(context, AppRoute.safetyBlockConfirm),
          ),
          HbActionRow(
            title: l.safetyReport,
            subtitle: l.safetyReportBody,
            asset: 'assets/icons/people_report.svg',
            color: c.pink,
            fill: c.pinkSoft,
            onPressed: () => _open(context, AppRoute.safetyReport),
          ),
        ],
        if (ref.watch(PeopleFailure.provider)) Text(l.safetyError),
        const HbPreviewNote(),
      ],
    );
  }

  void _open(BuildContext context, AppRoute route) {
    Navigator.pop(context);
    unawaited(context.pushNamed<void>(route.name));
  }
}
