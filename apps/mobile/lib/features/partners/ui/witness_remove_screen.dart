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

class WitnessRemoveScreen extends ConsumerWidget {
  const WitnessRemoveScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final peer = ref.watch(selectedPeerProvider);
    return HbResultScreen(
      title: l.witnessRemoveHeading,
      body: l.witnessRemoveBody,
      details: [
        Text(l.witnessRemoveNote),
        if (ref.watch(PeopleFailure.provider)) Text(l.safetyError),
      ],
      actions: [
        HbButton(
          label: l.witnessRemoveButton,
          onPressed: () {
            if (ref
                .read(PeopleController.provider.notifier)
                .removeWitness(peer))
              context.goNamed(AppRoute.witnessRemoved.name);
          },
        ),
        HbButton(
          label: l.witnessKeep,
          variant: HbButtonVariant.secondary,
          onPressed: () => context.goNamed(AppRoute.witnessManage.name),
        ),
      ],
    );
  }
}
