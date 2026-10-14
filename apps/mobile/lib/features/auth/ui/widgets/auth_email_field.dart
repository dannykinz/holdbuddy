import 'package:flutter/material.dart';

import '../../../../app/theme/tokens.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_field.dart';
import '../../domain/auth_validation.dart';

class AuthEmailField extends StatelessWidget {
  const AuthEmailField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.onChanged,
  });
  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => HbField(
    label: AppLocalizations.of(context).authEmail,
    labelStyle: AuthTokens.fieldLabel,
    controller: controller,
    enabled: enabled,
    keyboardType: TextInputType.emailAddress,
    autofillHints: const [AutofillHints.email],
    textInputAction: TextInputAction.next,
    validator: (value) => AuthValidation.validEmail(value ?? '')
        ? null
        : AppLocalizations.of(context).authEmailError,
    onChanged: onChanged,
  );
}
