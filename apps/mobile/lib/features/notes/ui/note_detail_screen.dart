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
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_field.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../logic/note_controller.dart';
import '../logic/note_search.dart';
import 'note_palette.dart';

class NoteDetailScreen extends ConsumerStatefulWidget {
  const NoteDetailScreen({super.key, this.noteId});
  final String? noteId;
  @override
  ConsumerState<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends ConsumerState<NoteDetailScreen> {
  late final _body = TextEditingController(
    text: ref.read(selectedNoteProvider(widget.noteId))?.body ?? '',
  );
  bool _invalid = false;
  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final note = ref.watch(selectedNoteProvider(widget.noteId));
    if (note == null) return const NavigationError();
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.noteDetail),
      topBar: const HbPageHeader(fallback: AppRoute.notes),
      content: [
        Text(
          l10n.noteDateChapter(
            DateFormat.MMMd(l10n.localeName).format(note.createdAt),
            note.chapter,
          ),
          style: Tokens.small.copyWith(color: colors.muted),
        ),
        HbHeading(title: note.chapterName),
        HbField(
          label: l10n.sessionYourNote,
          controller: _body,
          maxLines: NoteTokens.detailLines,
          minimumHeight: NoteTokens.detailHeight,
          fillColor: note.category.colors(colors).soft,
          errorText: _invalid ? l10n.noteRequired : null,
        ),
        Text(
          l10n.noteSavedPrivate,
          style: Tokens.small.copyWith(color: colors.muted),
        ),
        HbButton(
          label: l10n.noteTryRecall,
          variant: HbButtonVariant.secondary,
          onPressed: () =>
              context.pushNamed(AppRoute.noteRecall.name, extra: note.id),
        ),
      ],
      actions: [
        HbButton(
          label: l10n.noteSave,
          onPressed: () {
            if (_body.text.trim().isEmpty) {
              setState(() => _invalid = true);
              return;
            }
            ref
                .read(NoteController.provider.notifier)
                .save(note.copyWith(body: _body.text));
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l10n.noteSaved)));
          },
        ),
      ],
    );
  }
}
