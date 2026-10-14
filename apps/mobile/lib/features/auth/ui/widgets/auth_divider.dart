import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) => Row(
    spacing: Tokens.space12,
    children: [
      Expanded(child: Divider(color: AppColors.of(context).line)),
      Text(
        AppLocalizations.of(context).authOr,
        style: AuthTokens.dividerLabel.copyWith(
          color: AppColors.of(context).subtle,
        ),
      ),
      Expanded(child: Divider(color: AppColors.of(context).line)),
    ],
  );
}
