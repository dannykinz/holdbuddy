import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_hero_tile.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';
import '../../domain/settings_pane.dart';
import '../../logic/settings_controller.dart';
import '../../logic/settings_navigation.dart';
import 'settings_feedback.dart';

class SessionReminderResult extends ConsumerWidget {
  const SessionReminderResult({super.key, required this.enabled});
  final bool enabled;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final minute = ref.watch(SettingsController.provider).reminderMinute;
    return HbPageScaffold(
      topBar: HbPageHeader(onBack: () => _home(ref)),
      content: [
        HbHeroTile(
          asset: 'assets/icons/settings_bell_hero.svg',
          color: colors.pink,
          fill: colors.pinkSoft,
          size: SettingsTokens.heroSize,
          radius: SettingsTokens.heroRadius,
        ),
        HbHeading(
          title: enabled ? l10n.reminderEnabledTitle : l10n.reminderDeniedTitle,
          description: enabled
              ? l10n.reminderEnabledBody(
                  TimeOfDay(
                    hour: minute ~/ 60,
                    minute: minute % 60,
                  ).format(context),
                )
              : l10n.reminderDeniedBody,
        ),
      ],
      actions: _actions(context, ref),
      footnote: const SettingsFeedback(reminders: true),
    );
  }

  List<Widget> _actions(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (enabled)
      return [HbButton(label: l10n.settingsDone, onPressed: () => _home(ref))];
    return [
      HbButton(
        label: l10n.reminderOpenSettings,
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.reminderPhoneSettingsPreview)),
        ),
      ),
      HbButton(
        label: l10n.reminderKeepOff,
        variant: HbButtonVariant.secondary,
        onPressed: () {
          ref.read(SettingsController.provider.notifier).keepRemindersOff();
          _home(ref);
        },
      ),
    ];
  }

  void _home(WidgetRef ref) =>
      ref.read(SettingsNavigation.provider.notifier).open(SettingsPane.home);
}
