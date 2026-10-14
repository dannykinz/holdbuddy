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
import '../domain/auth_operation.dart';
import '../domain/auth_outcome.dart';
import '../domain/auth_request.dart';
import '../logic/auth_controller.dart';
import 'widgets/auth_failure.dart';
import 'widgets/auth_hero.dart';
import 'widgets/auth_scaffold.dart';

class PasswordResultScreen extends ConsumerWidget {
  const PasswordResultScreen({super.key, required this.saved});
  final bool saved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(AuthController.provider);
    final email = state.email.isEmpty ? l10n.authEmailDestination : state.email;
    return AuthScaffold(
      route: saved ? AppRoute.passwordSaved : AppRoute.passwordEmailSent,
      fallback: AppRoute.signIn,
      content: [
        AuthHero(icon: saved ? 'check' : 'mail'),
        HbHeading(
          title: saved ? l10n.authPasswordSaved : l10n.authCheckEmail,
          description: saved
              ? l10n.authPasswordSavedBody
              : l10n.authResetSentBody(email),
        ),
        if (!saved)
          Text(
            l10n.authResetExpiry,
            style: Tokens.body.copyWith(color: AppColors.of(context).muted),
          ),
        if (state.hasFailure) const AuthFailure(),
      ],
      actions: [
        HbButton(
          label: saved ? l10n.signIn : l10n.authBackSignIn,
          onPressed: () => context.goNamed(AppRoute.signIn.name),
        ),
        if (!saved)
          HbButton(
            label: l10n.authResendReset,
            variant: HbButtonVariant.ghost,
            loading: state.isBusy,
            onPressed: () => _resend(context, ref, email),
          ),
      ],
    );
  }

  Future<void> _resend(
    BuildContext context,
    WidgetRef ref,
    String email,
  ) async {
    final outcome = await ref
        .read(AuthController.provider.notifier)
        .submit(AuthRequest(AuthOperation.sendReset, email: email));
    if (!context.mounted || ModalRoute.isCurrentOf(context) != true) return;
    if (outcome == AuthOutcome.resetSent)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).authResetResent)),
      );
    if (outcome == AuthOutcome.offline)
      unawaited(context.pushNamed<void>(AppRoute.accountOffline.name));
  }
}
