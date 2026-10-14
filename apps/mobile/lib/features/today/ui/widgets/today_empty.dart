import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_hero_tile.dart';

class TodayEmpty extends StatelessWidget {
  const TodayEmpty({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space24,
      children: [
        const SizedBox(height: Tokens.minTouchTarget),
        HbHeroTile(
          asset: 'assets/icons/daily_empty_book.svg',
          color: colors.sky,
          fill: colors.skySoft,
          size: DailyTokens.emptyHeroSize,
          radius: DailyTokens.emptyHeroRadius,
        ),
        HbHeading(
          title: l10n.todayEmptyBefore,
          accent: l10n.todayEmptyAccent,
          after: l10n.headlinePeriod,
          description: l10n.todayEmptyBody,
        ),
        HbButton(
          label: l10n.todayCreatePlan,
          onPressed: () => context.pushNamed(AppRoute.scope.name),
        ),
      ],
    );
  }
}
