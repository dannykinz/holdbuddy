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
import '../../../core/widgets/hb_field.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_notice.dart';
import '../domain/auth_operation.dart';
import '../domain/auth_outcome.dart';
import '../domain/auth_request.dart';
import '../domain/auth_validation.dart';
import '../logic/auth_controller.dart';
import 'widgets/auth_age_confirmation.dart';
import 'widgets/auth_divider.dart';
import 'widgets/auth_email_field.dart';
import 'widgets/auth_failure.dart';
import 'widgets/auth_password_field.dart';
import 'widgets/auth_scaffold.dart';

class AccountFormScreen extends ConsumerStatefulWidget {
  const AccountFormScreen({super.key, required this.createAccount});
  final bool createAccount;

  @override
  ConsumerState<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends ConsumerState<AccountFormScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _submitted = false;
  bool _rejected = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  AuthRequest get _request => AuthRequest(
    widget.createAccount ? AuthOperation.signUp : AuthOperation.signIn,
    name: _name.text,
    email: _email.text,
    password: _password.text,
    isAdult: ref.read(AuthController.provider).isAdult,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(AuthController.provider);
    final invalid = widget.createAccount && _submitted && !_request.isValid;
    return Form(
      key: _form,
      autovalidateMode: _submitted
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: AuthScaffold(
        route: widget.createAccount ? AppRoute.signUp : AppRoute.signIn,
        gap: widget.createAccount ? Tokens.space16 : Tokens.space20,
        content: _content(invalid, state.isBusy),
        actions: [
          HbButton(
            label: widget.createAccount
                ? l10n.authCreateAccount
                : _rejected
                ? l10n.authTrySignIn
                : l10n.signIn,
            loading: state.isBusy,
            onPressed: invalid || (widget.createAccount && !state.isAdult)
                ? null
                : _submit,
          ),
          if (widget.createAccount && !invalid) _terms(),
        ],
      ),
    );
  }

  List<Widget> _content(bool invalid, bool busy) {
    final l10n = AppLocalizations.of(context);
    return [
      _heading(invalid),
      if (_rejected)
        HbNotice(
          title: l10n.authSignInFailure,
          body: l10n.authSignInFailureBody,
        ),
      if (!invalid && !_rejected) ...[_google(), const AuthDivider()],
      if (widget.createAccount) _nameField(busy),
      AuthEmailField(
        controller: _email,
        enabled: !busy,
        onChanged: (_) => setState(() {}),
      ),
      AuthPasswordField(
        label: l10n.authPassword,
        controller: _password,
        enabled: !busy,
        newPassword: widget.createAccount,
        showHint: widget.createAccount && !invalid,
        onChanged: (_) => setState(() {}),
      ),
      if (widget.createAccount) const AuthAgeConfirmation(),
      if (!widget.createAccount) _forgot(),
      if (ref.watch(AuthController.provider).hasFailure) const AuthFailure(),
    ];
  }

  Widget _heading(bool invalid) {
    final l10n = AppLocalizations.of(context);
    final signUp = widget.createAccount;
    if (invalid) return HbHeading(title: l10n.authValidationTitle);
    if (_rejected) return HbHeading(title: l10n.authTryAgainTitle);
    return HbHeading(
      title: signUp ? l10n.authCreateBefore : l10n.authWelcomeBefore,
      accent: signUp ? l10n.authCreateAccent : l10n.authWelcomeAccent,
      after: l10n.authHeadlineAfter,
    );
  }

  Widget _google() => HbButton(
    label: AppLocalizations.of(context).continueGoogle,
    google: true,
    variant: HbButtonVariant.secondary,
    onPressed: () => context.pushNamed(AppRoute.googleHandoff.name),
  );

  Widget _nameField(bool busy) => HbField(
    label: AppLocalizations.of(context).authName,
    labelStyle: AuthTokens.fieldLabel,
    controller: _name,
    enabled: !busy,
    autofillHints: const [AutofillHints.name],
    textInputAction: TextInputAction.next,
    validator: (value) => AuthValidation.validName(value ?? '')
        ? null
        : AppLocalizations.of(context).authNameError,
    onChanged: (_) => setState(() {}),
  );

  Widget _forgot() => Align(
    alignment: _rejected ? Alignment.center : Alignment.centerRight,
    child: TextButton(
      onPressed: () => context.pushNamed(AppRoute.forgotPassword.name),
      child: Text(
        _rejected
            ? AppLocalizations.of(context).authResetMine
            : AppLocalizations.of(context).authForgot,
      ),
    ),
  );

  Widget _terms() => TextButton(
    onPressed: () => context.pushNamed(AppRoute.legalPrivacy.name),
    child: Text(
      AppLocalizations.of(context).authTerms,
      textAlign: TextAlign.center,
      style: AuthTokens.finePrint.copyWith(color: AppColors.of(context).subtle),
    ),
  );

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (!(_form.currentState?.validate() ?? false) || !_request.isValid) return;
    FocusScope.of(context).unfocus();
    final pending = ref.read(AuthController.provider.notifier).submit(_request);
    if (!widget.createAccount)
      unawaited(
        context.pushNamed<void>(AppRoute.accountLoading.name, extra: true),
      );
    final outcome = await pending;
    if (!mounted) return;
    if (outcome == AuthOutcome.created &&
        ModalRoute.isCurrentOf(context) == true)
      unawaited(context.pushNamed<void>(AppRoute.verifyEmail.name));
    if (widget.createAccount &&
        outcome == AuthOutcome.offline &&
        ModalRoute.isCurrentOf(context) == true)
      unawaited(context.pushNamed<void>(AppRoute.accountOffline.name));
    if (outcome == AuthOutcome.invalidCredentials)
      setState(() => _rejected = true);
  }
}
