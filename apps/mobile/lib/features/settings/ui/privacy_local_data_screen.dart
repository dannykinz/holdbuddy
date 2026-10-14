import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_action_row.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_notice.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_sheet.dart';
import 'widgets/backup_preview_sheet.dart';

class PrivacyLocalDataScreen extends StatelessWidget {
  const PrivacyLocalDataScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.privacyLocalData),
      topBar: const HbPageHeader(fallback: AppRoute.settings),
      content: [
        HbHeading(title: l10n.privacyLocalTitle),
        HbActionRow(
          title: l10n.privacyNotes,
          subtitle: l10n.privacyNotesBody,
          asset: 'assets/icons/privacy_lock.svg',
          color: colors.green,
          fill: colors.greenSoft,
          onPressed: () => context.goNamed(AppRoute.notes.name),
        ),
        HbActionRow(
          title: l10n.privacyWitness,
          subtitle: l10n.privacyWitnessBody,
          asset: 'assets/icons/privacy_eye.svg',
          color: colors.purple,
          fill: colors.purpleSoft,
          onPressed: () => context.pushNamed(AppRoute.witnessManage.name),
        ),
        HbNotice(
          iconSize: Tokens.space20,
          title: l10n.privacyChangingPhone,
          body: l10n.privacyChangingPhoneBody,
          asset: 'assets/icons/privacy_info.svg',
        ),
      ],
      actions: [
        HbButton(
          label: l10n.settingsBackup,
          variant: HbButtonVariant.secondary,
          onPressed: () => HbSheet.show<void>(
            context: context,
            title: l10n.settingsBackup,
            child: const BackupPreviewSheet(),
          ),
        ),
        HbButton(
          label: l10n.privacyRemove,
          variant: HbButtonVariant.ghost,
          destructive: true,
          onPressed: () =>
              context.pushNamed(AppRoute.dataRemoveConfirmation.name),
        ),
      ],
    );
  }
}
