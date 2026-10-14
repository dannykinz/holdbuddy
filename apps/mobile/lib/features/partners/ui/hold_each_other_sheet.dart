import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_avatar.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../logic/people_controller.dart';
import '../logic/people_failure.dart';

class HoldEachOtherSheet extends ConsumerWidget {
  const HoldEachOtherSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peer = ref.watch(selectedPeerProvider);
    final l = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space16,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HbAvatar(
              image: const AssetImage('assets/avatars/people_you.png'),
              label: l.todayProfile,
              size: PeopleTokens.heroAvatar,
            ),
            HbAvatar(
              image: AssetImage(peer.avatar),
              label: peer.name,
              size: PeopleTokens.heroAvatar,
            ),
          ],
        ),
        Semantics(
          header: true,
          child: Text(
            l.mutualTitle,
            textAlign: TextAlign.center,
            style: Tokens.title,
          ),
        ),
        Text(l.mutualBody, textAlign: TextAlign.center, style: Tokens.body),
        HbButton(
          label: l.mutualBeWitness(peer.name),
          onPressed: peer.blocked
              ? null
              : () {
                  if (!ref
                      .read(PeopleController.provider.notifier)
                      .accept(peer))
                    return;
                  Navigator.pop(context);
                  unawaited(
                    context.pushNamed<void>(AppRoute.partnerTheirPlan.name),
                  );
                },
        ),
        HbButton(
          label: l.mutualLater,
          variant: HbButtonVariant.ghost,
          onPressed: () => Navigator.pop(context),
        ),
        if (ref.watch(PeopleFailure.provider)) Text(l.safetyError),
        const HbPreviewNote(),
      ],
    );
  }
}
