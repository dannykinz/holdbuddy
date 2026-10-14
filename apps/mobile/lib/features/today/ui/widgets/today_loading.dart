import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_heading.dart';

class TodayLoading extends StatelessWidget {
  const TodayLoading({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      liveRegion: true,
      label: l10n.loading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Tokens.space20,
        children: [
          Row(
            spacing: DailyTokens.dateGap,
            children: [
              for (var index = 0; index < 7; index++)
                Expanded(
                  child: _placeholder(
                    context,
                    WidgetTokens.dayHeight,
                    Tokens.radiusField,
                  ),
                ),
            ],
          ),
          HbHeading(title: l10n.todayLoadingTitle),
          _placeholder(
            context,
            DailyTokens.skeletonLineHeight,
            Tokens.radiusField,
          ),
          _placeholder(
            context,
            DailyTokens.skeletonCardHeight,
            Tokens.radiusCard,
          ),
          _placeholder(
            context,
            DailyTokens.skeletonRowHeight,
            DailyTokens.subcardRadius,
          ),
          Text(
            l10n.todayLoadingBody,
            style: Tokens.small.copyWith(color: AppColors.of(context).muted),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context, double height, double radius) =>
      Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.of(context).soft,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}
