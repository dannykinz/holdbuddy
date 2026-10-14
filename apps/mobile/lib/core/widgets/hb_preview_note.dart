import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import '../l10n/generated/app_localizations.dart';

class HbPreviewNote extends StatelessWidget {
  const HbPreviewNote({super.key, this.text});
  final String? text;
  @override
  Widget build(BuildContext context) => Text(
    text ?? AppLocalizations.of(context).uiPreview,
    textAlign: TextAlign.center,
    style: Tokens.small.copyWith(color: AppColors.of(context).muted),
  );
}
