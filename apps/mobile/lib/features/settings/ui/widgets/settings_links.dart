import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_action_row.dart';
import '../../../../core/widgets/hb_avatar.dart';
import '../../../partners/logic/people_controller.dart';
import '../../domain/appearance_mode.dart';
import '../../domain/settings_pane.dart';
import '../../logic/settings_controller.dart';
import '../../logic/settings_navigation.dart';
import 'settings_other_links.dart';

class SettingsLinks extends ConsumerWidget {
  const SettingsLinks({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final preferences = ref.watch(SettingsController.provider);
    return Column(
      spacing: Tokens.space20,
      children: [
        HbActionRow(
          title: l10n.settingsAppearance,
          subtitle: _appearance(l10n, preferences.appearance),
          asset: 'assets/icons/settings_sun.svg',
          color: colors.orange,
          fill: colors.orangeSoft,
          onPressed: () => context.pushNamed(AppRoute.appearance.name),
        ),
        HbActionRow(
          title: l10n.settingsSessionReminders,
          subtitle: _reminderTime(context, ref),
          asset: 'assets/icons/settings_bell.svg',
          color: colors.pink,
          fill: colors.pinkSoft,
          onPressed: () => ref
              .read(SettingsNavigation.provider.notifier)
              .open(SettingsPane.reminders),
        ),
        _partners(context, ref),
        const SettingsOtherLinks(),
      ],
    );
  }

  String _appearance(AppLocalizations l10n, AppearanceMode mode) =>
      switch (mode) {
        AppearanceMode.light => l10n.settingsLightDefault,
        AppearanceMode.dark => l10n.appearanceDark,
        AppearanceMode.system => l10n.appearanceSystem,
      };
  String _reminderTime(BuildContext context, WidgetRef ref) {
    final minute = ref.watch(SettingsController.provider).reminderMinute;
    return AppLocalizations.of(context).settingsStudyDays(
      TimeOfDay(hour: minute ~/ 60, minute: minute % 60).format(context),
    );
  }

  Widget _partners(BuildContext context, WidgetRef ref) => Card.outlined(
    child: InkWell(
      borderRadius: BorderRadius.circular(Tokens.radiusCard),
      onTap: () => context.pushNamed(AppRoute.partners.name),
      child: Padding(
        padding: const EdgeInsets.all(Tokens.space16),
        child: Row(
          spacing: Tokens.space12,
          children: [
            _partnerPortrait(context),
            _partnerCopy(context, ref),
            SvgPicture.asset(
              'assets/icons/settings_chevron.svg',
              excludeFromSemantics: true,
              colorFilter: ColorFilter.mode(
                AppColors.of(context).subtle,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    ),
  );
  Widget _partnerPortrait(BuildContext context) => HbAvatar(
    image: const AssetImage('assets/avatars/settings_witness.png'),
    size: DailyTokens.rowTileSize,
    label: AppLocalizations.of(context).settingsPartners,
    ringColor: AppColors.of(context).sky,
  );
  Widget _partnerCopy(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: DailyTokens.copyGap,
        children: [
          Text(l10n.settingsPartners, style: Tokens.strong),
          Text(
            _partnerNames(
              l10n,
              ref
                  .watch(PeopleController.provider)
                  .where(
                    (peer) => !peer.blocked && (peer.holdsMe || peer.iHold),
                  )
                  .map((peer) => peer.name)
                  .toList(),
            ),
            style: Tokens.small.copyWith(color: AppColors.of(context).muted),
          ),
        ],
      ),
    );
  }

  String _partnerNames(AppLocalizations l10n, List<String> names) {
    if (names.isEmpty) return '';
    if (names.length == 1) return names.first;
    return l10n.settingsNameJoin(
      names.take(names.length - 1).join(', '),
      names.last,
    );
  }
}
