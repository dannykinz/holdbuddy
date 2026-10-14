import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_avatar.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_info_list.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../../partners/logic/people_controller.dart';
import '../../partners/logic/people_failure.dart';

class BlockConfirmSheet extends ConsumerWidget {
  const BlockConfirmSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final peer = ref.watch(selectedPeerProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space16,
      children: [
        Center(
          child: HbAvatar(
            image: AssetImage(peer.avatar),
            label: peer.name,
            size: PeopleTokens.heroAvatar,
          ),
        ),
        Semantics(
          header: true,
          child: Text(
            l.safetyBlockQuestion(peer.name),
            textAlign: TextAlign.center,
            style: Tokens.title,
          ),
        ),
        HbInfoList(
          soft: true,
          items: [
            l.safetyBlock1,
            l.safetyBlock2,
            l.safetyBlock3,
            l.safetyBlock4,
          ],
        ),
        HbButton(
          label: l.safetyBlockName(peer.name),
          destructive: true,
          onPressed: () {
            if (!ref.read(PeopleController.provider.notifier).block(peer))
              return;
            context.goNamed(AppRoute.partners.name);
          },
        ),
        HbButton(
          label: l.safetyCancel,
          variant: HbButtonVariant.ghost,
          onPressed: () => Navigator.pop(context),
        ),
        if (ref.watch(PeopleFailure.provider)) Text(l.safetyError),
        const HbPreviewNote(),
      ],
    );
  }
}
