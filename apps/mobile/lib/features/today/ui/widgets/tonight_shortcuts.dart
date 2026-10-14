import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../plan/logic/current_chapter.dart';
import '../../../tasks/logic/task_controller.dart';

class TonightShortcuts extends ConsumerWidget {
  const TonightShortcuts({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapter = ref.watch(currentChapterProvider)?.number ?? 1;
    final tasks = ref.watch(chapterTasksProvider(chapter));
    final done = tasks.where((task) => task.done).length;
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: DailyTokens.rowGap,
      children: [
        Expanded(
          child: _tile(
            context,
            chapter: chapter,
            label: l10n.tasksLabel,
            title: l10n.previewTasks(done, tasks.length),
            fill: colors.soft,
            color: colors.muted,
            route: AppRoute.chapter,
            footer: _taskProgress(context, tasks.length, done),
          ),
        ),
        Expanded(
          child: _tile(
            context,
            chapter: chapter,
            label: l10n.noteLabel,
            title: l10n.writeOne,
            fill: colors.purpleSoft,
            color: colors.purple,
            route: AppRoute.noteNew,
            footer: SvgPicture.asset(
              'assets/icons/daily_note_pen.svg',
              excludeFromSemantics: true,
              colorFilter: ColorFilter.mode(colors.purple, BlendMode.srcIn),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tile(
    BuildContext context, {
    required int chapter,
    required String label,
    required String title,
    required Color fill,
    required Color color,
    required AppRoute route,
    required Widget footer,
  }) => Material(
    color: fill,
    borderRadius: BorderRadius.circular(DailyTokens.subcardRadius),
    child: InkWell(
      onTap: () => context.pushNamed(route.name, extra: chapter),
      borderRadius: BorderRadius.circular(DailyTokens.subcardRadius),
      child: Padding(
        padding: const EdgeInsets.all(DailyTokens.subcardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: DailyTokens.subcardGap,
          children: [
            Text(label, style: Tokens.dataLabel.copyWith(color: color)),
            Row(
              spacing: DailyTokens.copyGap,
              children: [
                Expanded(child: Text(title, style: Tokens.strong)),
                _chevron(color),
              ],
            ),
            footer,
          ],
        ),
      ),
    ),
  );

  Widget _chevron(Color color) {
    return SvgPicture.asset(
      'assets/icons/daily_chevron.svg',
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  Widget _taskProgress(BuildContext context, int count, int done) {
    final colors = AppColors.of(context);
    return Row(
      spacing: DailyTokens.subcardGap,
      children: [
        for (var index = 0; index < count; index++)
          Expanded(
            child: Container(
              height: DailyTokens.taskSegmentHeight,
              decoration: BoxDecoration(
                color: index < done ? colors.green : colors.line,
                borderRadius: BorderRadius.circular(
                  DailyTokens.taskSegmentRadius,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
