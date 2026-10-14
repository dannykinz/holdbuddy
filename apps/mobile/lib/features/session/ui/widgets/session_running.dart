import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';
import '../../../focus/domain/study_mode.dart';
import '../../../focus/logic/focus_controller.dart';
import '../../../focus/ui/focus_pill.dart';
import '../../logic/session_controller.dart';
import 'session_controls.dart';
import 'session_notes.dart';
import 'session_tasks.dart';
import 'session_timer.dart';

class SessionRunning extends ConsumerWidget {
  const SessionRunning({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(SessionController.provider);
    final focus = ref.watch(FocusController.provider);
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(SessionController.provider.notifier);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.session),
      topBar: HbPageHeader(
        center: focus.active ? const FocusPill() : null,
        title: state.isFirst
            ? state.planName
            : l10n.sessionChapterPlan(state.chapterNumber, state.planName),
        onBack: controller.leave,
      ),
      content: [
        HbHeading(title: state.chapterName),
        SessionTimer(showCaption: !state.isFirst),
        const SessionControls(),
        if (focus.active || focus.mode == StudyMode.tasks)
          const SessionTasks()
        else
          const SessionNotes(),
      ],
      footnote: focus.active
          ? Text(
              l10n.focusPreview,
              textAlign: TextAlign.center,
              style: Tokens.small.copyWith(color: AppColors.of(context).muted),
            )
          : null,
      actions: [
        HbButton(
          label: l10n.sessionEnd,
          onPressed: () {
            FocusScope.of(context).unfocus();
            controller.end();
          },
        ),
      ],
    );
  }
}
