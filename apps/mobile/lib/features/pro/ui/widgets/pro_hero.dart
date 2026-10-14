import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_hero_tile.dart';
import 'pro_badge.dart';

class ProHero extends StatelessWidget {
  const ProHero({super.key, this.welcome = false});
  final bool welcome;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Column(
      spacing: welcome ? Tokens.space16 : ProTokens.heroGap,
      children: [
        if (welcome)
          const ProBadge()
        else
          Center(
            child: SizedBox.square(
              dimension: ProTokens.heroSize,
              child: HbHeroTile(
                asset: 'assets/icons/pro_crown.svg',
                fill: colors.primary,
                color: colors.onPrimary,
                size: ProTokens.heroSize,
                radius: ProTokens.heroRadius,
              ),
            ),
          ),
        Semantics(
          header: true,
          child: Text(
            welcome ? l.proWelcomeTitle : l.proTitle,
            textAlign: TextAlign.center,
            style: welcome ? ProTokens.welcomeTitle : ProTokens.title,
          ),
        ),
        Text(
          welcome ? l.proWelcomeBody : l.proBody,
          textAlign: TextAlign.center,
          style: (welcome ? ProTokens.welcomeBody : ProTokens.body).copyWith(
            color: colors.muted,
          ),
        ),
      ],
    );
  }
}
