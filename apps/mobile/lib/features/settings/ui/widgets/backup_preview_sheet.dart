import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_notice.dart';

class BackupPreviewSheet extends StatelessWidget {
  const BackupPreviewSheet({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space16,
      children: [
        Text(
          l10n.backupPrivacy,
          style: Tokens.body.copyWith(color: AppColors.of(context).muted),
        ),
        HbNotice(
          title: l10n.settingsPreviewTitle,
          body: l10n.backupPreviewBody,
        ),
        HbButton(label: l10n.backupExport, onPressed: () => _preview(context)),
        HbButton(
          label: l10n.backupRestore,
          variant: HbButtonVariant.secondary,
          onPressed: () => _preview(context),
        ),
      ],
    );
  }

  void _preview(BuildContext context) => ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).backupPreviewBody)),
      );
}
