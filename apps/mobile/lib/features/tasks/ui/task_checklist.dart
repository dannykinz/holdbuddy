import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../plan/logic/current_chapter.dart';
import '../domain/study_task.dart';
import '../domain/task_kind.dart';
import '../logic/task_controller.dart';

class TaskChecklist extends ConsumerWidget {
  const TaskChecklist({super.key, this.onAdd, this.chapter});
  final int? chapter;
  final VoidCallback? onAdd;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final number = chapter ?? ref.watch(currentChapterProvider)?.number;
    if (number == null) return const SizedBox.shrink();
    final tasks = ref.watch(chapterTasksProvider(number));
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Tokens.space20,
          vertical: AuthTokens.noticeGap,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < tasks.length; index++) ...[
              if (index > 0) const Divider(height: WidgetTokens.lineWidth),
              _task(context, ref, tasks[index]),
            ],
            if (onAdd != null) ...[
              const Divider(height: WidgetTokens.lineWidth),
              TextButton.icon(
                onPressed: onAdd,
                icon: SvgPicture.asset(
                  'assets/icons/task_plus.svg',
                  excludeFromSemantics: true,
                  colorFilter: ColorFilter.mode(
                    AppColors.of(context).accent,
                    BlendMode.srcIn,
                  ),
                ),
                label: Text(AppLocalizations.of(context).taskAdd),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _task(BuildContext context, WidgetRef ref, StudyTask task) {
    final l10n = AppLocalizations.of(context);
    final title = switch (task.kind) {
      TaskKind.read => l10n.taskRead,
      TaskKind.examples => l10n.taskExamples,
      TaskKind.note => l10n.taskNote,
      TaskKind.custom => task.title,
    };
    return CheckboxListTile(
      value: task.done,
      onChanged: (_) => ref.read(TaskController.provider.notifier).toggle(task),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        title,
        style: Tokens.body.copyWith(
          color: task.done
              ? AppColors.of(context).subtle
              : AppColors.of(context).text,
          decoration: task.done ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}
