import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../logic/auth_controller.dart';

class AuthAgeConfirmation extends ConsumerWidget {
  const AuthAgeConfirmation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(AuthController.provider);
    return CheckboxListTile(
      value: state.isAdult,
      onChanged: state.isBusy
          ? null
          : (value) => ref
                .read(AuthController.provider.notifier)
                .confirmAge(value ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: AppColors.of(context).accent,
      title: Text(AppLocalizations.of(context).authAdult, style: Tokens.small),
    );
  }
}
