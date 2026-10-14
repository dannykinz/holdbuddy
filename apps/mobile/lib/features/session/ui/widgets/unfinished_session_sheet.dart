import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';

class UnfinishedSessionSheet extends StatelessWidget {
  const UnfinishedSessionSheet({super.key, required this.planName});
  final String planName;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space16,
      children: [
        Text(
          l10n.sessionUnfinishedBody(planName),
          style: Tokens.body.copyWith(color: AppColors.of(context).muted),
        ),
        HbButton(
          label: l10n.sessionReturnToCurrent,
          onPressed: () => Navigator.pop(context, true),
        ),
        HbButton(
          label: l10n.sessionNotNow,
          variant: HbButtonVariant.secondary,
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}
