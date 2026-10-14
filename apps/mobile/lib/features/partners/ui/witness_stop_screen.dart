import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_result_screen.dart';
import '../logic/people_controller.dart';
import '../logic/people_failure.dart';

class WitnessStopScreen extends ConsumerWidget {
  const WitnessStopScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final peer = ref.watch(selectedPeerProvider);
    return HbResultScreen(
      title: l.witnessStopHeading,
      body: l.witnessStopBody,
      details: [if (ref.watch(PeopleFailure.provider)) Text(l.safetyError)],
      actions: [
        HbButton(
          label: l.witnessStop,
          onPressed: () {
            if (ref
                .read(PeopleController.provider.notifier)
                .save(peer.copyWith(iHold: false)))
              context.goNamed(AppRoute.witnessAccessEnded.name);
          },
        ),
        HbButton(
          label: l.witnessKeepSharing,
          variant: HbButtonVariant.secondary,
          onPressed: () => context.goNamed(AppRoute.partnerTheirPlan.name),
        ),
      ],
    );
  }
}
