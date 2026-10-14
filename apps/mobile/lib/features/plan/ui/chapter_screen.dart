import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/app_route.dart';
import '../../../app/router/navigation_error.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_sheet.dart';
import '../../focus/logic/focus_controller.dart';
import '../../session/logic/session_controller.dart';
import '../../session/ui/widgets/session_mode_sheet.dart';
import '../../session/ui/widgets/unfinished_session_sheet.dart';
import '../../tasks/ui/add_task_sheet.dart';
import '../../tasks/ui/task_checklist.dart';
import '../logic/chosen_plan.dart';
import '../logic/current_chapter.dart';
import '../logic/plan_controller.dart';
import 'widgets/chapter_links.dart';

class ChapterScreen extends ConsumerStatefulWidget {
  const ChapterScreen({
    super.key,
    this.chooseMode = false,
    this.addTask = false,
    this.chapterNumber,
  });
  final bool chooseMode;
  final bool addTask;
  final int? chapterNumber;
  @override
  ConsumerState<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends ConsumerState<ChapterScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.chooseMode || widget.addTask)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.addTask) {
          unawaited(_addTask());
          return;
        }
        unawaited(_start());
      });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final plan = ref.watch(chosenPlanProvider);
    final chapter = ref.watch(chapterProvider(widget.chapterNumber));
    if (chapter == null) return const NavigationError();
    return HbPageScaffold(
      key: ValueKey(
        widget.chooseMode ? AppRoute.sessionChooseMode : AppRoute.chapter,
      ),
      topBar: const HbPageHeader(),
      gap: Tokens.space24,
      content: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Tokens.space8,
          children: [
            Text(
              l10n
                  .todayChapterOf(chapter.number, plan.totalUnits)
                  .toUpperCase(),
              style: Tokens.dataLabel.copyWith(
                color: AppColors.of(context).subtle,
              ),
            ),
            HbHeading(
              title: chapter.name,
              description: l10n.updatedChapterDate(
                DateFormat('EEE d MMM', l10n.localeName).format(chapter.date),
                TimeOfDay.fromDateTime(chapter.date).format(context),
                plan.contract.duration.inMinutes,
              ),
            ),
          ],
        ),
        TaskChecklist(onAdd: _addTask, chapter: chapter.number),
        ChapterLinks(chapter: chapter.number),
      ],
      actions: [HbButton(label: l10n.startSession, onPressed: _start)],
    );
  }

  Future<void> _start() async {
    final chapter = ref.read(chapterProvider(widget.chapterNumber));
    if (chapter == null) return;
    if (await _returnToUnfinished(chapter.number)) return;
    if (!mounted) return;
    final result = await HbSheet.show<bool>(
      context: context,
      title: AppLocalizations.of(context).sessionChooseTitle,
      child: const SessionModeSheet(),
    );
    if (!mounted) return;
    if (result != true) {
      if (widget.chooseMode) context.pop();
      return;
    }
    final focus = ref.read(FocusController.provider);
    context.pushReplacementNamed(
      focus.silence && !focus.allowed
          ? AppRoute.focusPermission.name
          : AppRoute.session.name,
      extra: chapter.number,
    );
  }

  Future<bool> _returnToUnfinished(int chapter) async {
    final controller = ref.read(SessionController.provider.notifier);
    if (!controller.hasUnfinishedSession) return false;
    final session = ref.read(SessionController.provider);
    final plan = ref.read(chosenPlanProvider);
    if (session.planId == plan.id && session.chapterNumber == chapter) {
      context.pushReplacementNamed(AppRoute.session.name, extra: chapter);
      return true;
    }
    final resume = await HbSheet.show<bool>(
      context: context,
      title: AppLocalizations.of(context).sessionUnfinishedTitle,
      child: UnfinishedSessionSheet(planName: session.planName),
    );
    if (!mounted || resume != true) return true;
    ref.read(ChosenPlan.provider.notifier).select(session.planId);
    context.pushReplacementNamed(
      AppRoute.session.name,
      extra: session.chapterNumber,
    );
    return true;
  }

  Future<void> _addTask() => HbSheet.show<void>(
    context: context,
    title: AppLocalizations.of(context).taskAdd,
    child: AddTaskSheet(
      chapter: ref.read(chapterProvider(widget.chapterNumber))?.number,
    ),
  );
}
