import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../deadline_copy.dart';

class DeadlineDateTile extends StatelessWidget {
  const DeadlineDateTile({super.key, required this.date, this.hero = false});
  final DateTime date;
  final bool hero;
  @override
  Widget build(BuildContext context) {
    final pair = DeadlineCopy.color(date).colors(AppColors.of(context));
    return Container(
      width: hero ? DeadlineTokens.heroDateWidth : DeadlineTokens.dateWidth,
      height: hero ? DeadlineTokens.heroDateHeight : DeadlineTokens.dateHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pair.soft,
        borderRadius: BorderRadius.circular(
          hero ? DeadlineTokens.heroDateRadius : Tokens.radiusField,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat.MMM(AppLocalizations.of(context).localeName)
                .format(date)
                .toUpperCase(),
            style: (hero ? DeadlineTokens.heroMonth : DeadlineTokens.month)
                .copyWith(color: pair.strong),
          ),
          Text(
            date.day.toString(),
            style: hero ? DeadlineTokens.heroDay : DeadlineTokens.day,
          ),
        ],
      ),
    );
  }
}
