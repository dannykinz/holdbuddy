import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_notice.dart';
import '../../domain/auth_outcome.dart';
import '../../logic/auth_controller.dart';

class AuthFailure extends ConsumerWidget {
  const AuthFailure({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outcome = ref.watch(AuthController.provider).outcome;
    if (outcome != AuthOutcome.unavailable &&
        outcome != AuthOutcome.invalidInput)
      return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        HbNotice(
          title: l10n.authUnavailableTitle,
          body: l10n.authUnavailableBody,
        ),
        HbButton(
          label: l10n.continueOffline,
          variant: HbButtonVariant.ghost,
          onPressed: () => context.pushNamed(AppRoute.accountOffline.name),
        ),
      ],
    );
  }
}
