import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_action_row.dart';
import '../../../core/widgets/hb_avatar.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_notice.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../../../core/widgets/hb_sheet.dart';
import '../domain/peer.dart';
import '../logic/people_controller.dart';
import 'witness_access_ended_screen.dart';
import 'witness_contact_sheet.dart';

class WitnessManageScreen extends ConsumerWidget {
  const WitnessManageScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peer = ref.watch(selectedPeerProvider);
    final l = AppLocalizations.of(context);
    final c = AppColors.of(context);
    if (peer.blocked || !peer.holdsMe) return const WitnessAccessEndedScreen();
    return HbPageScaffold(
      topBar: const HbPageHeader(fallback: AppRoute.partners),
      content: [
        _portrait(peer, c),
        HbHeading(
          title: l.witnessInCorner(peer.name),
          description: l.witnessAccepted(peer.contact),
        ),
        HbActionRow(
          title: l.witnessCanSee,
          subtitle: l.witnessSeeBody,
          asset: 'assets/icons/privacy_eye.svg',
          color: c.purple,
          fill: c.purpleSoft,
          trailing: const SizedBox.shrink(),
        ),
        HbNotice(title: l.witnessPrivacyTitle, body: l.witnessPrivacyBody),
      ],
      actions: [
        if (!peer.iHold && peer.planName.isNotEmpty)
          HbButton(
            label: l.mutualBeWitness(peer.name),
            onPressed: () =>
                context.pushNamed(AppRoute.partnerHoldEachOther.name),
          ),
        HbButton(
          label: l.witnessReplace,
          variant: HbButtonVariant.secondary,
          onPressed: () => HbSheet.show<void>(
            context: context,
            title: l.witnessReplace,
            child: const WitnessContactSheet(),
          ),
        ),
        HbButton(
          label: l.witnessRemove,
          variant: HbButtonVariant.ghost,
          onPressed: () =>
              context.pushNamed(AppRoute.witnessRemoveConfirmation.name),
        ),
        TextButton(
          onPressed: () => context.pushNamed(AppRoute.safetyOptions.name),
          child: Text(
            l.safetyReportBlock(peer.name),
            style: Tokens.small.copyWith(color: c.error),
          ),
        ),
      ],
      footnote: const HbPreviewNote(),
    );
  }

  Widget _portrait(Peer peer, AppColors c) {
    return Align(
      alignment: Alignment.centerLeft,
      child: HbAvatar(
        image: AssetImage(peer.avatar),
        label: peer.name,
        size: PeopleTokens.heroAvatar,
        ringColor: c.sky,
      ),
    );
  }
}
