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
import '../../../core/widgets/hb_code_input.dart';
import '../../../core/widgets/hb_field.dart';
import '../../../core/widgets/hb_heading.dart';
import '../domain/auth_operation.dart';
import '../domain/auth_outcome.dart';
import '../domain/auth_request.dart';
import '../domain/auth_validation.dart';
import '../logic/auth_controller.dart';
import 'widgets/auth_failure.dart';
import 'widgets/auth_hero.dart';
import 'widgets/auth_scaffold.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _code = TextEditingController();
  final _expiredCode = TextEditingController();
  bool _expired = false;
  bool _incomplete = false;

  @override
  void dispose() {
    _code.dispose();
    _expiredCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(AuthController.provider);
    final email = state.email.isEmpty ? l10n.authEmailDestination : state.email;
    return AuthScaffold(
      route: AppRoute.verifyEmail,
      fallback: AppRoute.signUp,
      content: [
        if (_expired) const AuthHero(icon: 'mail'),
        HbHeading(
          title: _expired ? l10n.authExpiredTitle : l10n.authCheckEmail,
          description: _expired
              ? l10n.authExpiredBody(email)
              : l10n.authVerifyBody(email),
        ),
        if (_expired)
          HbField(
            label: l10n.authCode,
            labelStyle: AuthTokens.fieldLabel,
            controller: _expiredCode,
            readOnly: true,
            errorText: l10n.authExpiredHint,
          )
        else
          HbCodeInput(
            label: l10n.authCode,
            labelStyle: AuthTokens.fieldLabel,
            controller: _code,
          ),
        if (_incomplete)
          Text(
            l10n.authCodeError,
            style: Tokens.small.copyWith(color: AppColors.of(context).accent),
          ),
        if (!_expired)
          HbButton(
            label: l10n.authResendCode,
            variant: HbButtonVariant.ghost,
            onPressed: state.isBusy ? null : _resend,
          ),
        if (state.hasFailure) const AuthFailure(),
      ],
      actions: [
        HbButton(
          label: _expired ? l10n.authNewCode : l10n.authVerify,
          onPressed: _expired ? _resend : _verify,
          loading: state.isBusy,
        ),
      ],
    );
  }

  Future<void> _verify() async {
    setState(() => _incomplete = !AuthValidation.validCode(_code.text));
    if (_incomplete) return;
    FocusScope.of(context).unfocus();
    final outcome = await ref
        .read(AuthController.provider.notifier)
        .submit(AuthRequest(AuthOperation.verify, code: _code.text));
    if (!mounted || ModalRoute.isCurrentOf(context) != true) return;
    if (outcome == AuthOutcome.verified)
      unawaited(context.pushNamed<void>(AppRoute.scope.name));
    if (outcome == AuthOutcome.expired)
      setState(() {
        _expired = true;
        _expiredCode.text = _code.text.split('').join('  ');
      });
    if (outcome == AuthOutcome.offline)
      unawaited(context.pushNamed<void>(AppRoute.accountOffline.name));
  }

  Future<void> _resend() async {
    final outcome = await ref
        .read(AuthController.provider.notifier)
        .submit(const AuthRequest(AuthOperation.resendCode));
    if (!mounted || ModalRoute.isCurrentOf(context) != true) return;
    if (outcome == AuthOutcome.offline) {
      unawaited(context.pushNamed<void>(AppRoute.accountOffline.name));
      return;
    }
    if (outcome != AuthOutcome.codeSent) return;
    setState(() {
      _expired = false;
      _incomplete = false;
      _code.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).authCodeResent)),
    );
  }
}
