import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../domain/study_note.dart';
import '../note_palette.dart';

class NoteListCard extends StatelessWidget {
  const NoteListCard({super.key, required this.note, required this.onPressed});
  final StudyNote note;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final palette = note.category.colors(colors);
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: palette.soft,
        borderRadius: BorderRadius.circular(Tokens.radiusCard),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(Tokens.radiusCard),
          child: Padding(
            padding: const EdgeInsets.all(Tokens.space20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Tokens.space12,
              children: [
                Text(note.chapterName, style: Tokens.strong),
                Text(
                  l10n.noteDateChapter(
                    DateFormat.MMMd(l10n.localeName).format(note.createdAt),
                    note.chapter,
                  ),
                  style: Tokens.small.copyWith(color: palette.strong),
                ),
                Text(note.body, style: Tokens.body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
