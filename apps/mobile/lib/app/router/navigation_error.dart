import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/hb_tab.dart';
import '../theme/app_colors.dart';
import '../theme/tokens.dart';
import 'app_route.dart';

class NavigationError extends StatelessWidget {
  const NavigationError({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Tokens.screenMargin),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Tokens.space24,
              children: [
                _icon(context),
                Text(
                  l10n.navigationHeading,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  l10n.navigationError,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                FilledButton(
                  onPressed: () => context.go(AppRoute.today.path),
                  child: Text(l10n.navigationReturn),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _icon(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: Tokens.iconTileSize,
      height: Tokens.iconTileSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.tint,
        borderRadius: BorderRadius.circular(Tokens.radiusIconTile),
      ),
      child: SvgPicture.asset(
        HbTab.today.iconAsset(selected: true),
        width: Tokens.navIconSize,
        height: Tokens.navIconSize,
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(colors.accent, BlendMode.srcIn),
      ),
    );
  }
}
