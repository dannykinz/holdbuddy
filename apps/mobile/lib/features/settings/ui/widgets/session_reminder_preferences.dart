import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_action_row.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';
import '../../../../core/widgets/hb_sheet.dart';
import '../../domain/settings_pane.dart';
import '../../logic/settings_controller.dart';
import '../../logic/settings_navigation.dart';
import 'reminder_lead_sheet.dart';
import 'settings_feedback.dart';

class SessionReminderPreferences extends ConsumerWidget {
  const SessionReminderPreferences({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return HbPageScaffold(
      topBar: HbPageHeader(onBack: () => _home(ref)),
      content: [
        HbHeading(
          title: l10n.reminderPreferencesTitle,
          description: l10n.reminderPreferencesBody,
        ),
        _studyDay(context, ref),
        _beforeSession(context, ref),
      ],
      actions: [
        HbButton(label: l10n.reminderEnable, onPressed: () => _enable(ref)),
        HbButton(
          label: l10n.reminderNotNow,
          variant: HbButtonVariant.ghost,
          onPressed: () => _home(ref),
        ),
      ],
      footnote: const SettingsFeedback(reminders: true),
    );
  }

  void _home(WidgetRef ref) =>
      ref.read(SettingsNavigation.provider.notifier).open(SettingsPane.home);
  void _enable(WidgetRef ref) {
    final enabled = ref
        .read(SettingsController.provider.notifier)
        .enableReminders();
    if (ref.read(settingsSaveFailureProvider)) return;
    ref
        .read(SettingsNavigation.provider.notifier)
        .open(
          enabled
              ? SettingsPane.remindersEnabled
              : SettingsPane.remindersDenied,
        );
  }

  Future<void> _time(BuildContext context, WidgetRef ref) async {
    final minute = ref.read(SettingsController.provider).reminderMinute;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: minute ~/ 60, minute: minute % 60),
    );
    if (!context.mounted || time == null) return;
    ref
        .read(SettingsController.provider.notifier)
        .reminderMinute(time.hour * 60 + time.minute);
  }

  Widget _studyDay(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final minute = ref.watch(SettingsController.provider).reminderMinute;
    return HbActionRow(
      title: l10n.reminderStudyDay,
      subtitle: l10n.reminderDaysTime(
        TimeOfDay(hour: minute ~/ 60, minute: minute % 60).format(context),
      ),
      asset: 'assets/icons/settings_bell.svg',
      color: colors.pink,
      fill: colors.pinkSoft,
      onPressed: () => _time(context, ref),
    );
  }

  Widget _beforeSession(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final settings = ref.watch(SettingsController.provider);
    return HbActionRow(
      title: l10n.reminderBeforeSession,
      subtitle: settings.beforeMinutes == 0
          ? l10n.reminderAtStart
          : l10n.reminderMinutesBefore(settings.beforeMinutes),
      asset: 'assets/icons/settings_clock.svg',
      color: colors.sky,
      fill: colors.skySoft,
      onPressed: () => HbSheet.show<void>(
        context: context,
        title: l10n.reminderBeforeSession,
        child: const ReminderLeadSheet(),
      ),
    );
  }
}
