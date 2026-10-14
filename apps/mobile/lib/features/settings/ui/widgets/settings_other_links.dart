import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_action_row.dart';
import '../../../../core/widgets/hb_category.dart';
import '../../../../core/widgets/hb_sheet.dart';
import '../../../partners/logic/people_controller.dart';
import '../../domain/settings_pane.dart';
import '../../logic/settings_controller.dart';
import '../../logic/settings_navigation.dart';
import 'backup_preview_sheet.dart';

class SettingsOtherLinks extends ConsumerWidget {
  const SettingsOtherLinks({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    spacing: Tokens.space20,
    children: [
      ..._tiles(context, ref, _studyRows(context, ref)),
      ..._tiles(context, ref, _privacyRows(context, ref)),
      _backup(context),
    ],
  );
  List<(String, String, String, HbCategory, AppRoute)> _studyRows(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(settingsPreviewProvider);
    return [
      (
        l10n.settingsDeadlines,
        l10n.settingsComingUp(data.deadlines),
        'bell',
        HbCategory.pink,
        AppRoute.reminders,
      ),
      (
        l10n.settingsFocus,
        l10n.settingsFocusBody,
        'focus',
        HbCategory.green,
        AppRoute.focusPermission,
      ),
      (
        l10n.settingsFiles,
        l10n.settingsFilesCount(data.files),
        'doc',
        HbCategory.purple,
        AppRoute.materialLibrary,
      ),
    ];
  }

  List<(String, String, String, HbCategory, AppRoute)> _privacyRows(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context);
    return [
      (
        l10n.settingsBlocked,
        l10n.settingsBlockedCount(
          ref
              .watch(PeopleController.provider)
              .where((peer) => peer.blocked)
              .length,
        ),
        'doc',
        HbCategory.purple,
        AppRoute.safetyOptions,
      ),
      (
        l10n.settingsPrivacy,
        l10n.settingsPrivacyBody,
        'shield',
        HbCategory.green,
        AppRoute.privacyLocalData,
      ),
    ];
  }

  List<Widget> _tiles(
    BuildContext context,
    WidgetRef ref,
    List<(String, String, String, HbCategory, AppRoute)> rows,
  ) => [
    for (final (title, body, icon, category, route) in rows)
      HbActionRow(
        title: title,
        subtitle: body,
        asset: 'assets/icons/settings_$icon.svg',
        color: category.colors(AppColors.of(context)).strong,
        fill: category.colors(AppColors.of(context)).soft,
        onPressed: () {
          if (route == AppRoute.safetyOptions) {
            ref
                .read(SettingsNavigation.provider.notifier)
                .open(SettingsPane.blocked);
            return;
          }
          unawaited(context.pushNamed<void>(route.name));
        },
      ),
  ];
  Widget _backup(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return HbActionRow(
      title: l10n.settingsBackup,
      subtitle: l10n.settingsBackupBody,
      asset: 'assets/icons/settings_doc.svg',
      color: AppColors.of(context).purple,
      fill: AppColors.of(context).purpleSoft,
      onPressed: () => HbSheet.show<void>(
        context: context,
        title: l10n.settingsBackup,
        child: const BackupPreviewSheet(),
      ),
    );
  }
}
