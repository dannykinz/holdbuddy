import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_category.dart';
import '../../../../core/widgets/hb_icon_tile.dart';
import '../../domain/deadline.dart';
import '../../domain/deadline_status.dart';
import '../deadline_copy.dart';

class DeadlineCompletedCard extends StatelessWidget {
  const DeadlineCompletedCard({super.key, required this.deadline});
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
        child: Row(
          spacing: Tokens.space12,
          children: [
            HbIconTile(
              asset: deadline.status == DeadlineStatus.done
                  ? 'assets/icons/reminder_check.svg'
                  : 'assets/icons/reminder_archive.svg',
              category: deadline.status == DeadlineStatus.done
                  ? HbCategory.green
                  : HbCategory.sky,
            ),
            Expanded(child: _copy(context)),
          ],
        ),
      ),
    ),
  );
  Widget _copy(BuildContext context) {
    final done = deadline.status == DeadlineStatus.done;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: DeadlineTokens.copyGap,
      children: [
        Text(
          deadline.title,
          style: Tokens.strong.copyWith(
            color: done
                ? AppColors.of(context).subtle
                : AppColors.of(context).text,
            decoration: done ? TextDecoration.lineThrough : null,
          ),
        ),
        Text(
          _subtitle(context),
          style: DeadlineTokens.shortMeta.copyWith(
            color: AppColors.of(context).muted,
          ),
        ),
      ],
    );
  }

  String _subtitle(BuildContext context) {
    final l = AppLocalizations.of(context);
    final doneAt = deadline.doneAt;
    if (deadline.status == DeadlineStatus.done && doneAt != null) {
      return l.deadlineFinished(
        DateFormat.MMMd(l.localeName).format(doneAt),
        DeadlineCopy.finished(l, deadline.dueAt, doneAt),
      );
    }
    return l.deadlineDue(
      DeadlineCopy.category(l, deadline.category),
      DateFormat.MMMd(l.localeName).format(deadline.dueAt),
    );
  }
}
