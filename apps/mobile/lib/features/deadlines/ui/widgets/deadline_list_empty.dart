import 'package:flutter/material.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_category.dart';
import '../../../../core/widgets/hb_empty_state.dart';
import '../../domain/deadline_status.dart';

class DeadlineListEmpty extends StatelessWidget {
  const DeadlineListEmpty({super.key, required this.status});
  final DeadlineStatus status;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (title, body, asset, category) = switch (status) {
      DeadlineStatus.upcoming => (
        l.deadlineUpcomingEmpty,
        l.deadlineUpcomingEmptyBody,
        'assets/icons/daily_calendar_hero.svg',
        HbCategory.orange,
      ),
      DeadlineStatus.done => (
        l.deadlineDoneEmpty,
        l.deadlineDoneEmptyBody,
        'assets/icons/daily_done_check.svg',
        HbCategory.green,
      ),
      DeadlineStatus.archived => (
        l.deadlineArchivedEmpty,
        l.deadlineArchivedEmptyBody,
        'assets/icons/daily_calendar_hero.svg',
        HbCategory.sky,
      ),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Tokens.space24),
      child: HbEmptyState(
        title: title,
        description: body,
        asset: asset,
        category: category,
      ),
    );
  }
}
