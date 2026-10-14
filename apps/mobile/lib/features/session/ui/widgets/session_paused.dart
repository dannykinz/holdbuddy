import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_action_row.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';
import '../../logic/session_controller.dart';
import 'session_timer.dart';

class SessionPaused extends ConsumerWidget {
  const SessionPaused({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(SessionController.provider);
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final controller = ref.read(SessionController.provider.notifier);
    return HbPageScaffold(
      topBar: HbPageHeader(
        title: l10n.sessionChapterPlan(state.chapterNumber, state.planName),
        onBack: controller.leave,
      ),
      content: [
        HbHeading(
          title: l10n.sessionPausedTitle,
          description: l10n.sessionPausedBody,
        ),
        const SessionTimer(showCaption: false),
        HbActionRow(
          title: state.chapterName,
          subtitle: l10n.sessionStudied(
            state.elapsedSeconds ~/ 60,
            state.elapsedSeconds % 60,
          ),
          asset: 'assets/icons/daily_book.svg',
          color: colors.sky,
          fill: colors.skySoft,
          trailing: const SizedBox.shrink(),
        ),
      ],
      actions: [
        HbButton(label: l10n.sessionResume, onPressed: controller.resume),
        HbButton(
          label: l10n.sessionEnd,
          variant: HbButtonVariant.secondary,
          onPressed: controller.end,
        ),
      ],
    );
  }
}
