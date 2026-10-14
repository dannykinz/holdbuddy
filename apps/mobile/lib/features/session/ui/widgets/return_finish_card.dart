import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';

class ReturnFinishCard extends StatelessWidget {
  const ReturnFinishCard({
    super.key,
    required this.date,
    required this.previous,
  });
  final DateTime date;
  final DateTime previous;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Tokens.radiusCard),
        side: BorderSide(color: colors.tintLine),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Tokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Tokens.space20,
          children: [
            Text(
              l10n.dailyNewFinish,
              style: Tokens.small.copyWith(color: colors.muted),
            ),
            Text(
              DateFormat.MMMMd(l10n.localeName).format(date),
              style: Tokens.display,
            ),
            Text(
              DateFormat('EEEE, y', l10n.localeName).format(date),
              style: Tokens.body.copyWith(color: colors.muted),
            ),
            const Divider(height: WidgetTokens.lineWidth),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.previously,
                    style: Tokens.small.copyWith(color: colors.muted),
                  ),
                ),
                Text(
                  DateFormat.MMMMd(l10n.localeName).format(previous),
                  style: Tokens.small.copyWith(color: colors.muted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
