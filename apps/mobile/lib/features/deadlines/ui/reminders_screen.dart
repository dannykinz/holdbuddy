import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_segmented.dart';
import '../domain/deadline.dart';
import '../domain/deadline_status.dart';
import '../logic/deadline_controller.dart';
import '../logic/deadline_providers.dart';
import '../logic/deadline_tab.dart';
import 'widgets/deadline_completed_card.dart';
import 'widgets/deadline_failure_notice.dart';
import 'widgets/deadline_list_empty.dart';
import 'widgets/deadline_swipe_row.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key, this.revealFirst = false});
  final bool revealFirst;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final selected = ref.watch(DeadlineTab.provider);
    return HbPageScaffold(
      topBar: const HbPageHeader(),
      content: [
        HbHeading(title: l.deadlineTitle, description: l.deadlineSubtitle),
        HbSegmented(
          labels: [l.deadlineUpcoming, l.deadlineDone, l.deadlineArchived],
          selected: selected.index,
          onSelected: (index) => ref
              .read(DeadlineTab.provider.notifier)
              .select(DeadlineStatus.values[index]),
        ),
        if (ref.watch(DeadlineController.provider).hasError)
          const DeadlineFailureNotice(),
        AsyncView(
          value: ref.watch(deadlinesProvider),
          onRetry: () => ref.invalidate(deadlinesProvider),
          builder: (context, deadlines) => _list(context, deadlines, selected),
        ),
      ],
      actions: [
        HbButton(
          label: l.deadlineAdd,
          onPressed: () => context.pushNamed(AppRoute.reminderNew.name),
        ),
      ],
    );
  }

  Widget _list(
    BuildContext context,
    List<Deadline> deadlines,
    DeadlineStatus status,
  ) {
    final visible = deadlines.where((item) => item.status == status).toList()
      ..sort(
        (a, b) => status == DeadlineStatus.done
            ? (b.doneAt ?? b.dueAt).compareTo(a.doneAt ?? a.dueAt)
            : a.dueAt.compareTo(b.dueAt),
      );
    if (visible.isEmpty) return DeadlineListEmpty(status: status);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space20,
      children: [
        for (final (index, deadline) in visible.indexed)
          _card(deadline, status, index),
        if (status != DeadlineStatus.upcoming)
          Text(
            AppLocalizations.of(context).deadlineRetained,
            style: DeadlineTokens.shortMeta.copyWith(
              color: AppColors.of(context).subtle,
            ),
          ),
      ],
    );
  }

  Widget _card(Deadline deadline, DeadlineStatus status, int index) =>
      status == DeadlineStatus.upcoming
      ? DeadlineSwipeRow(
          key: ValueKey(deadline.id),
          deadline: deadline,
          revealed: revealFirst && index == 0,
        )
      : DeadlineCompletedCard(deadline: deadline);
}
