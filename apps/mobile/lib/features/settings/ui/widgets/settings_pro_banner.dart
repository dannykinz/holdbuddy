import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_hero_tile.dart';
import '../../../pro/logic/pro_controller.dart';

class SettingsProBanner extends ConsumerWidget {
  const SettingsProBanner({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final enabled = ref.watch(ProController.provider).enabled;
    return Material(
      color: colors.primary,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(SettingsTokens.proRadius),
      child: InkWell(
        onTap: () => context.pushNamed(
          enabled ? AppRoute.proWelcome.name : AppRoute.proPaywall.name,
        ),
        child: Padding(
          padding: const EdgeInsets.all(Tokens.space16),
          child: _content(context, enabled),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, bool enabled) {
    final colors = AppColors.of(context);
    return Row(
      spacing: SettingsTokens.proGap,
      children: [
        HbHeroTile(
          asset: 'assets/icons/settings_crown.svg',
          color: colors.primary,
          fill: colors.onPrimary,
          size: Tokens.iconTileSize,
          radius: Tokens.radiusIconTile,
        ),
        Expanded(child: _copy(context, enabled)),
        SvgPicture.asset(
          'assets/icons/settings_pro_chevron.svg',
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(colors.onPrimary, BlendMode.srcIn),
        ),
      ],
    );
  }

  Widget _copy(BuildContext context, bool enabled) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: DailyTokens.copyGap,
      children: [
        Text(
          l10n.settingsPro,
          style: SettingsTokens.proTitle.copyWith(color: colors.onPrimary),
        ),
        Text(
          enabled ? l10n.proActiveBody : l10n.settingsProBody,
          style: SettingsTokens.proBody.copyWith(color: colors.onPrimary),
        ),
      ],
    );
  }
}
