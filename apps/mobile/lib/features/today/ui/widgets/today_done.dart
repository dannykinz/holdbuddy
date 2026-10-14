import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_hero_tile.dart';
import '../../../notes/logic/note_controller.dart';
import '../../../plan/logic/current_chapter.dart';
import '../../../session/ui/widgets/session_next.dart';
import '../../domain/today_view.dart';
import '../../logic/today_controller.dart';

class TodayDone extends ConsumerWidget {
  const TodayDone({super.key, required this.view});
  final TodayView view;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final first = view == TodayView.firstDone;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space20,
      children: [
        HbHeroTile(
          asset: 'assets/icons/daily_done_check.svg',
          color: colors.green,
          fill: colors.greenSoft,
          size: AuthTokens.heroSize,
          radius: AuthTokens.heroRadius,
        ),
        HbHeading(
          title: l10n.todayDoneBefore,
          accent: l10n.todayDoneAccent,
          after: l10n.headlinePeriod,
          description: first ? l10n.sessionFirstCovered : l10n.todayDoneBody,
        ),
        SessionNext(chapter: ref.watch(currentChapterProvider)),
        HbButton(
          label: l10n.todayReadNote,
          variant: HbButtonVariant.secondary,
          onPressed: () {
            final receipt = ref.read(latestPlanReceiptProvider);
            final notes = ref
                .read(NoteController.provider)
                .where((note) => note.chapter == receipt?.chapterNumber)
                .toList();
            unawaited(
              context.pushNamed<void>(
                notes.isEmpty
                    ? AppRoute.noteNew.name
                    : AppRoute.noteDetail.name,
                extra: notes.isEmpty ? receipt?.chapterNumber : notes.first.id,
              ),
            );
          },
        ),
      ],
    );
  }
}
