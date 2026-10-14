import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_heading.dart';
import '../domain/auth_operation.dart';
import '../domain/auth_outcome.dart';
import '../domain/auth_request.dart';
import '../logic/auth_controller.dart';
import 'widgets/auth_email_field.dart';
import 'widgets/auth_failure.dart';
import 'widgets/auth_password_field.dart';
import 'widgets/auth_scaffold.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  const PasswordScreen({super.key, required this.reset});
  final bool reset;

  @override
  ConsumerState<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(AuthController.provider);
    final busy = state.isBusy;
    return Form(
      key: _form,
      autovalidateMode: _submitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: AuthScaffold(
        route: widget.reset ? AppRoute.resetPassword : AppRoute.forgotPassword,
        fallback: AppRoute.signIn,
        content: [
          HbHeading(
            title: widget.reset
                ? l10n.authFreshPassword
                : l10n.authRecoveryTitle,
            description: widget.reset ? null : l10n.authRecoveryBody,
          ),
          if (widget.reset)
            ..._passwords(busy)
          else
            AuthEmailField(controller: _email, enabled: !busy),
          if (state.hasFailure) const AuthFailure(),
        ],
        actions: [
          HbButton(
            label: widget.reset ? l10n.authSavePassword : l10n.authSendReset,
            onPressed: _submit,
            loading: busy,
          ),
        ],
      ),
    );
  }

  List<Widget> _passwords(bool busy) {
    final l10n = AppLocalizations.of(context);
    return [
      AuthPasswordField(
        label: l10n.authNewPassword,
        controller: _password,
        enabled: !busy,
        newPassword: true,
        showHint: true,
      ),
      AuthPasswordField(
        label: l10n.authConfirmPassword,
        controller: _confirmation,
        enabled: !busy,
        newPassword: true,
        validator: (value) =>
            value == _password.text && (value ?? '').isNotEmpty
            ? null
            : l10n.authPasswordMismatch,
      ),
    ];
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (!(_form.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    final request = AuthRequest(
      widget.reset ? AuthOperation.savePassword : AuthOperation.sendReset,
      email: _email.text,
      password: _password.text,
      confirmation: _confirmation.text,
    );
    final outcome = await ref
        .read(AuthController.provider.notifier)
        .submit(request);
    if (!mounted || ModalRoute.isCurrentOf(context) != true) return;
    if (outcome == AuthOutcome.offline) {
      unawaited(context.pushNamed<void>(AppRoute.accountOffline.name));
      return;
    }
    final destination = switch (outcome) {
      AuthOutcome.resetSent => AppRoute.passwordEmailSent,
      AuthOutcome.passwordSaved => AppRoute.passwordSaved,
      _ => null,
    };
    if (destination != null)
      unawaited(context.pushNamed<void>(destination.name));
  }
}
