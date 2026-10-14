import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_action_row.dart';
import '../../../plan/domain/plan_chapter.dart';

class SessionNext extends StatelessWidget {
  const SessionNext({super.key, required this.chapter, this.date});
  final PlanChapter? chapter;
  final DateTime? date;
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    final next = chapter;
    return HbActionRow(
      title: next == null
          ? l10n.planFinished
          : DateFormat(
              'EEE, d MMM · h:mm a',
              l10n.localeName,
            ).format(date ?? next.date),
      subtitle: next == null
          ? l10n.todaySeePlan
          : l10n.sessionNext(l10n.noteChapter(next.number, next.name)),
      asset: 'assets/icons/daily_calendar.svg',
      color: colors.orange,
      fill: colors.orangeSoft,
      onPressed: () => next == null
          ? context.goNamed(AppRoute.plan.name)
          : context.pushNamed(AppRoute.chapter.name, extra: next.number),
    );
  }
}
