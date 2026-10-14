import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_field.dart';
import '../../domain/auth_validation.dart';

class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.newPassword = false,
    this.showHint = false,
  });
  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool newPassword;
  final bool showHint;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mode = Theme.of(context).brightness == Brightness.dark ? 'dark_' : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: WidgetTokens.fieldLabelGap,
      children: [
        HbField(
          label: widget.label,
          labelStyle: AuthTokens.fieldLabel,
          controller: widget.controller,
          obscureText: _obscured,
          validator: widget.validator ?? _validate,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          textInputAction: TextInputAction.done,
          autofillHints: [
            widget.newPassword
                ? AutofillHints.newPassword
                : AutofillHints.password,
          ],
          suffixIcon: IconButton(
            tooltip: _obscured ? l10n.authShowPassword : l10n.authHidePassword,
            onPressed: widget.enabled
                ? () => setState(() => _obscured = !_obscured)
                : null,
            constraints: const BoxConstraints(minWidth: Tokens.minTouchTarget),
            icon: SvgPicture.asset(
              'assets/icons/auth_${mode}eye.svg',
              excludeFromSemantics: true,
            ),
          ),
        ),
        if (widget.showHint)
          Text(
            l10n.authPasswordHint,
            style: Tokens.small.copyWith(color: AppColors.of(context).muted),
          ),
      ],
    );
  }

  String? _validate(String? value) {
    final password = value ?? '';
    final l10n = AppLocalizations.of(context);
    if (password.runes.length > AuthValidation.maximumPasswordLength)
      return l10n.authPasswordLengthError;
    if (widget.newPassword && !AuthValidation.validPassword(password))
      return l10n.authPasswordHint;
    if (password.isEmpty) return l10n.authPasswordError;
    return null;
  }
}
