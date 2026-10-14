import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../logic/settings_controller.dart';

class SettingsFeedback extends ConsumerWidget {
  const SettingsFeedback({super.key, this.reminders = false});
  final bool reminders;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final failed = ref.watch(settingsSaveFailureProvider);
    return Semantics(
      liveRegion: failed,
      child: Text(
        failed
            ? l10n.settingsSaveError
            : reminders
            ? l10n.reminderPreview
            : l10n.settingsPreferencesPreview,
        textAlign: TextAlign.center,
        style: Tokens.small.copyWith(
          color: failed
              ? AppColors.of(context).accent
              : AppColors.of(context).muted,
        ),
      ),
    );
  }
}
