import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_note_card.dart';
import '../../../../core/widgets/hb_section_heading.dart';
import '../../../notes/logic/note_controller.dart';
import '../../../notes/ui/note_palette.dart';

class TodayNotes extends ConsumerWidget {
  const TodayNotes({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(NoteController.provider);
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space12,
      children: [
        HbSectionHeading(
          title: l10n.todayRecentNotes,
          action: l10n.todaySeeAll,
          onPressed: () => context.goNamed(AppRoute.notes.name),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: DailyTokens.rowGap,
            children: [
              for (var index = 0; index < notes.length; index++)
                HbNoteCard(
                  title: l10n.noteChapter(
                    notes[index].chapter,
                    notes[index].chapterName,
                  ),
                  body: notes[index].body.split('\n').first,
                  fill: notes[index].category.colors(colors).soft,
                  onPressed: () => context.pushNamed(
                    AppRoute.noteDetail.name,
                    extra: notes[index].id,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
