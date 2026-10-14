import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_category.dart';
import '../../../../core/widgets/hb_chip.dart';
import '../../../deadlines/domain/deadline.dart';
import '../../../deadlines/logic/deadline_providers.dart';
import '../../../deadlines/ui/deadline_copy.dart';
import '../../../deadlines/ui/widgets/deadline_date_tile.dart';

class TodayReminder extends ConsumerWidget {
  const TodayReminder({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deadline = ref.watch(nearestDeadlineProvider);
    if (deadline == null) return const SizedBox.shrink();
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DailyTokens.subcardRadius),
        side: BorderSide(color: AppColors.of(context).line),
      ),
      child: InkWell(
        onTap: () =>
            context.pushNamed(AppRoute.reminderDetail.name, extra: deadline.id),
        borderRadius: BorderRadius.circular(DailyTokens.subcardRadius),
        child: Padding(
          padding: const EdgeInsets.all(Tokens.space12),
          child: _row(context, deadline),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, Deadline deadline) {
    final large =
        MediaQuery.textScalerOf(context).scale(Tokens.space16) >
        Tokens.space16 * DeadlineTokens.largeTextThreshold;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Tokens.space8,
      children: [
        Row(
          spacing: Tokens.space12,
          children: [
            DeadlineDateTile(date: deadline.dueAt),
            Expanded(child: _copy(context, deadline)),
            if (!large) _badge(context, deadline),
          ],
        ),
        if (large) _badge(context, deadline),
      ],
    );
  }

  Widget _copy(BuildContext context, Deadline deadline) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: DailyTokens.copyGap,
      children: [
        Text(deadline.title, style: Tokens.strong),
        Text(
          l.todayDue(DateFormat.MMMd(l.localeName).format(deadline.dueAt)),
          style: Tokens.small.copyWith(color: AppColors.of(context).muted),
        ),
      ],
    );
  }

  Widget _badge(BuildContext context, Deadline deadline) => HbChip(
    label: DeadlineCopy.timing(AppLocalizations.of(context), deadline.dueAt),
    category: HbCategory.orange,
  );
}
