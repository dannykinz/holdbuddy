import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../domain/deadline.dart';
import '../domain/deadline_status.dart';
import '../logic/deadline_controller.dart';
import '../logic/deadline_providers.dart';
import '../logic/deadline_tab.dart';
import 'deadline_copy.dart';
import 'widgets/deadline_date_tile.dart';
import 'widgets/deadline_failure_notice.dart';
import 'widgets/deadline_timeline.dart';
import 'widgets/deadline_unavailable.dart';

class ReminderDetailScreen extends ConsumerWidget {
  const ReminderDetailScreen({super.key, this.deadlineId});
  final String? deadlineId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deadlines = ref.watch(deadlinesProvider);
    final nearest = ref.watch(nearestDeadlineProvider);
    final state = ref.watch(DeadlineController.provider);
    return AsyncView(
      value: deadlines,
      onRetry: () => ref.invalidate(deadlinesProvider),
      builder: (context, deadlines) {
        final id = deadlineId ?? nearest?.id;
        final selected = deadlines.where((item) => item.id == id);
        if (selected.isEmpty) return const DeadlineUnavailable();
        return _page(context, ref, selected.first, state);
      },
    );
  }

  Widget _page(
    BuildContext context,
    WidgetRef ref,
    Deadline deadline,
    AsyncValue<void> state,
  ) {
    final upcoming = deadline.status == DeadlineStatus.upcoming;
    return HbPageScaffold(
      topBar: HbPageHeader(
        fallback: AppRoute.reminders,
        trailing: upcoming ? _edit(context, deadline) : null,
      ),
      content: [
        _heading(context, deadline),
        DeadlineTimeline(deadline: deadline),
        if (state.hasError) const DeadlineFailureNotice(),
      ],
      actions: _actions(context, ref, deadline, state),
      footnote: HbPreviewNote(
        text: AppLocalizations.of(context).deadlinePreview,
      ),
    );
  }

  List<Widget> _actions(
    BuildContext context,
    WidgetRef ref,
    Deadline deadline,
    AsyncValue<void> state,
  ) {
    final l = AppLocalizations.of(context);
    final upcoming = deadline.status == DeadlineStatus.upcoming;
    return [
      if (upcoming)
        HbButton(
          label: l.deadlineMarkDone,
          loading: state.isLoading,
          onPressed: state.isLoading
              ? null
              : () => _change(context, ref, deadline, DeadlineStatus.done),
        ),
      if (deadline.status != DeadlineStatus.archived)
        _archive(context, ref, deadline),
      if (!upcoming)
        HbButton(
          label: l.deadlineReturn,
          onPressed: () => _return(context, ref, deadline.status),
        ),
    ];
  }

  Widget _heading(BuildContext context, Deadline deadline) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Tokens.space12,
      children: [
        DeadlineDateTile(date: deadline.dueAt, hero: true),
        Text(deadline.title, style: DeadlineTokens.detailTitle),
        Text(
          l.deadlineDetailDue(
            DeadlineCopy.category(l, deadline.category),
            DateFormat.MMMd(l.localeName).format(deadline.dueAt),
            DeadlineCopy.timing(l, deadline.dueAt),
          ),
          style: Tokens.small.copyWith(color: AppColors.of(context).muted),
        ),
      ],
    );
  }

  Widget _edit(BuildContext context, Deadline deadline) => IconButton(
    tooltip: AppLocalizations.of(context).deadlineEditAction,
    onPressed: () =>
        context.pushNamed(AppRoute.reminderNew.name, extra: deadline),
    style: IconButton.styleFrom(backgroundColor: AppColors.of(context).soft),
    icon: SvgPicture.asset(
      'assets/icons/reminder_edit.svg',
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(
        AppColors.of(context).text,
        BlendMode.srcIn,
      ),
    ),
  );
  Widget _archive(BuildContext context, WidgetRef ref, Deadline deadline) =>
      TextButton.icon(
        onPressed: ref.read(DeadlineController.provider).isLoading
            ? null
            : () => _change(context, ref, deadline, DeadlineStatus.archived),
        icon: SvgPicture.asset(
          'assets/icons/reminder_archive_small.svg',
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(
            AppColors.of(context).text,
            BlendMode.srcIn,
          ),
        ),
        label: Text(
          AppLocalizations.of(context).deadlineArchive,
          style: Tokens.strong.copyWith(color: AppColors.of(context).text),
        ),
      );
  Future<void> _change(
    BuildContext context,
    WidgetRef ref,
    Deadline deadline,
    DeadlineStatus status,
  ) async {
    final saved = await ref
        .read(DeadlineController.provider.notifier)
        .changeStatus(deadline, status);
    if (!context.mounted || saved == null) return;
    _return(context, ref, status);
  }

  void _return(BuildContext context, WidgetRef ref, DeadlineStatus status) {
    ref.read(DeadlineTab.provider.notifier).select(status);
    context.goNamed(AppRoute.reminders.name);
  }
}
