import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../logic/settings_controller.dart';

class ReminderLeadSheet extends ConsumerWidget {
  const ReminderLeadSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(SettingsController.provider).beforeMinutes;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space16,
      children: [
        Text(
          lead == 0 ? l10n.reminderAtStart : l10n.reminderMinutesBefore(lead),
          style: Tokens.strong,
        ),
        Slider(
          value: lead.toDouble(),
          max: SettingsTokens.reminderMaximumLead.toDouble(),
          divisions:
              SettingsTokens.reminderMaximumLead ~/
              SettingsTokens.reminderLeadStep,
          semanticFormatterCallback: (value) =>
              l10n.reminderMinutesBefore(value.round()),
          onChanged: (value) => ref
              .read(SettingsController.provider.notifier)
              .beforeMinutes(value.round()),
        ),
        HbButton(
          label: l10n.settingsDone,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
