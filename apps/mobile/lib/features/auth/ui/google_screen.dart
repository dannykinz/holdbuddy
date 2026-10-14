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
import '../../../core/widgets/hb_notice.dart';
import '../domain/auth_operation.dart';
import '../domain/auth_request.dart';
import '../logic/auth_controller.dart';
import 'widgets/auth_age_confirmation.dart';
import 'widgets/auth_scaffold.dart';

class GoogleScreen extends ConsumerWidget {
  const GoogleScreen({super.key, this.cancelled = false});
  final bool cancelled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(AuthController.provider);
    return AuthScaffold(
      route: cancelled ? AppRoute.googleCancelled : AppRoute.googleHandoff,
      onBack: cancelled
          ? null
          : () => context.replaceNamed(AppRoute.googleCancelled.name),
      content: [
        if (!cancelled) _portrait(context),
        HbHeading(
          title: cancelled
              ? l10n.authGoogleCancelledTitle
              : l10n.authGoogleTitle,
          description: cancelled
              ? l10n.authGoogleCancelledBody
              : l10n.authGoogleBody,
        ),
        if (!cancelled)
          HbNotice(title: l10n.authPrivateTitle, body: l10n.authPrivateBody),
        if (!cancelled) const AuthAgeConfirmation(),
      ],
      actions: [
        HbButton(
          label: cancelled ? l10n.authRetryGoogle : l10n.authOpenGoogle,
          google: true,
          onPressed: cancelled
              ? () => context.replaceNamed(AppRoute.googleHandoff.name)
              : !state.isAdult || state.isBusy
              ? null
              : () => _open(context, ref),
        ),
        HbButton(
          label: l10n.authUseEmail,
          variant: HbButtonVariant.secondary,
          onPressed: () => context.pushNamed(AppRoute.signUp.name),
        ),
      ],
    );
  }

  Widget _portrait(BuildContext context) {
    final mode = Theme.of(context).brightness == Brightness.dark ? 'dark_' : '';
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: AuthTokens.heroSize,
        height: AuthTokens.heroSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.of(context).orange,
            width: AuthTokens.portraitRing,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/avatars/auth_${mode}you.png',
            excludeFromSemantics: true,
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context, WidgetRef ref) {
    unawaited(
      ref
          .read(AuthController.provider.notifier)
          .submit(
            AuthRequest(
              AuthOperation.google,
              isAdult: ref.read(AuthController.provider).isAdult,
            ),
          ),
    );
    unawaited(
      context.pushNamed<void>(AppRoute.accountLoading.name, extra: true),
    );
  }
}
