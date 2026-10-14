import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_chip.dart';
import '../../domain/deadline.dart';
import '../deadline_copy.dart';
import 'deadline_date_tile.dart';
import 'deadline_stops.dart';

class DeadlineCard extends StatelessWidget {
  const DeadlineCard({super.key, required this.deadline});
  final Deadline deadline;
  @override
  Widget build(BuildContext context) => Card.outlined(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(DeadlineTokens.cardRadius),
      side: BorderSide(color: AppColors.of(context).line),
    ),
    child: InkWell(
      onTap: () =>
          context.pushNamed(AppRoute.reminderDetail.name, extra: deadline.id),
      borderRadius: BorderRadius.circular(DeadlineTokens.cardRadius),
      child: Padding(
        padding: const EdgeInsets.all(Tokens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Tokens.space12,
          children: [
            _top(context),
            if (_largeText(context)) _badge(context),
            DeadlineStops(deadline: deadline),
          ],
        ),
      ),
    ),
  );
  Widget _top(BuildContext context) => Row(
    spacing: Tokens.space12,
    children: [
      DeadlineDateTile(date: deadline.dueAt),
      Expanded(child: _copy(context)),
      if (!_largeText(context)) _badge(context),
    ],
  );
  Widget _copy(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: DeadlineTokens.copyGap,
      children: [
        Text(deadline.title, style: Tokens.strong),
        Text(
          l.deadlineDue(
            DeadlineCopy.category(l, deadline.category),
            DateFormat.MMMd(l.localeName).format(deadline.dueAt),
          ),
          style: DeadlineTokens.shortMeta.copyWith(
            color: AppColors.of(context).muted,
          ),
        ),
      ],
    );
  }

  bool _largeText(BuildContext context) =>
      MediaQuery.textScalerOf(context).scale(Tokens.space16) >
      Tokens.space16 * DeadlineTokens.largeTextThreshold;
  Widget _badge(BuildContext context) => HbChip(
    label: DeadlineCopy.timing(AppLocalizations.of(context), deadline.dueAt),
    category: DeadlineCopy.color(deadline.dueAt),
    labelStyle: DeadlineTokens.badge,
    padding: DeadlineTokens.badgePadding,
  );
}
