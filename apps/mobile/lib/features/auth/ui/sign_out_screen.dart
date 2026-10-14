import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_notice.dart';
import '../domain/auth_operation.dart';
import '../domain/auth_outcome.dart';
import '../domain/auth_request.dart';
import '../logic/auth_controller.dart';
import 'widgets/auth_failure.dart';
import 'widgets/auth_scaffold.dart';

class SignOutScreen extends ConsumerWidget {
  const SignOutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(AuthController.provider);
    return AuthScaffold(
      route: AppRoute.signOutConfirm,
      fallback: AppRoute.settings,
      content: [
        HbHeading(
          title: l10n.authSignOutTitle,
          description: l10n.authSignOutBody,
        ),
        HbNotice(
          title: l10n.authSharedPhoneTitle,
          body: l10n.authSharedPhoneBody,
        ),
        if (state.hasFailure) const AuthFailure(),
      ],
      actions: [
        HbButton(
          label: l10n.authSignOut,
          loading: state.isBusy,
          onPressed: () => _signOut(context, ref),
        ),
        HbButton(
          label: l10n.authStaySignedIn,
          variant: HbButtonVariant.secondary,
          onPressed: () => context.goNamed(AppRoute.settings.name),
        ),
      ],
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final outcome = await ref
        .read(AuthController.provider.notifier)
        .submit(const AuthRequest(AuthOperation.signOut));
    if (!context.mounted) return;
    if (outcome == AuthOutcome.signedOut) {
      context.goNamed(AppRoute.getStarted.name);
    }
    if (outcome == AuthOutcome.offline)
      unawaited(context.pushNamed<void>(AppRoute.accountOffline.name));
  }
}
