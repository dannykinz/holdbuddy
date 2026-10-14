import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_action_row.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../domain/appearance_mode.dart';
import '../logic/settings_controller.dart';
import 'widgets/settings_feedback.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.appearance),
      topBar: const HbPageHeader(fallback: AppRoute.settings),
      content: [
        HbHeading(
          title: l10n.appearanceTitle,
          description: l10n.appearanceBody,
        ),
        for (final mode in AppearanceMode.values) _choice(context, ref, mode),
      ],
      footnote: const SettingsFeedback(),
      actions: [
        HbButton(label: l10n.settingsDone, onPressed: () => context.pop()),
      ],
    );
  }

  Widget _choice(BuildContext context, WidgetRef ref, AppearanceMode mode) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final selected = ref.watch(SettingsController.provider).appearance == mode;
    final (title, body, icon) = _labels(l10n, mode);
    return Semantics(
      selected: selected,
      child: HbActionRow(
        title: title,
        subtitle: selected ? l10n.appearanceSelected(body) : body,
        asset: 'assets/icons/$icon.svg',
        color: mode == AppearanceMode.light ? colors.orange : colors.purple,
        fill: mode == AppearanceMode.light
            ? colors.orangeSoft
            : colors.purpleSoft,
        selected: selected,
        onPressed: () =>
            ref.read(SettingsController.provider.notifier).appearance(mode),
      ),
    );
  }

  (String, String, String) _labels(AppLocalizations l10n, AppearanceMode mode) {
    return switch (mode) {
      AppearanceMode.light => (
        l10n.appearanceLight,
        l10n.appearanceLightBody,
        'settings_sun',
      ),
      AppearanceMode.dark => (
        l10n.appearanceDark,
        l10n.appearanceDarkBody,
        'appearance_moon',
      ),
      AppearanceMode.system => (
        l10n.appearanceSystem,
        l10n.appearanceSystemBody,
        'appearance_device',
      ),
    };
  }
}
