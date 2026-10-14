import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/router/navigation_error.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_field.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_hero_tile.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../logic/note_search.dart';
import 'note_palette.dart';

class NoteRecallScreen extends ConsumerStatefulWidget {
  const NoteRecallScreen({super.key, this.noteId});
  final String? noteId;
  @override
  ConsumerState<NoteRecallScreen> createState() => _NoteRecallScreenState();
}

class _NoteRecallScreenState extends ConsumerState<NoteRecallScreen> {
  late final _recall = TextEditingController(
    text: ref.read(selectedNoteProvider(widget.noteId))?.recallQuestion ?? '',
  );
  @override
  void dispose() {
    _recall.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final note = ref.watch(selectedNoteProvider(widget.noteId));
    if (note == null) return const NavigationError();
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    void reveal() =>
        context.pushReplacementNamed(AppRoute.noteDetail.name, extra: note.id);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.noteRecall),
      topBar: const HbPageHeader(fallback: AppRoute.notes),
      content: [
        HbHeroTile(
          asset: 'assets/icons/note_recall.svg',
          color: note.category.colors(colors).strong,
          fill: note.category.colors(colors).soft,
        ),
        HbHeading(
          title: l10n.noteRecallTitle,
          description: l10n.noteRecallFrom(note.chapterName),
        ),
        HbField(
          label: l10n.noteRecallWords,
          controller: _recall,
          maxLines: NoteTokens.recallLines,
          minimumHeight: NoteTokens.recallHeight,
        ),
        Text(
          l10n.noteRecallBody,
          style: Tokens.small.copyWith(color: colors.muted),
        ),
      ],
      actions: [
        HbButton(label: l10n.noteReveal, onPressed: reveal),
        HbButton(
          label: l10n.noteSkipRecall,
          variant: HbButtonVariant.ghost,
          onPressed: reveal,
        ),
      ],
    );
  }
}
