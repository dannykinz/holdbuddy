import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../plan/domain/plan_view.dart';
import '../../plan/logic/current_chapter.dart';
import '../../plan/logic/plan_controller.dart';
import '../logic/note_controller.dart';
import 'widgets/notes_privacy.dart';

class NewNoteScreen extends ConsumerStatefulWidget {
  const NewNoteScreen({super.key, this.chapter});
  final int? chapter;
  @override
  ConsumerState<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends ConsumerState<NewNoteScreen> {
  late final _draft = ref.read(noteDraftProvider);
  late final _body = TextEditingController(
    text: widget.chapter != null && widget.chapter != _draft.chapter
        ? ''
        : _draft.body,
  );
  late int _chapter =
      ref.read(chapterProvider(widget.chapter ?? _draft.chapter))?.number ??
      ref.read(currentChapterProvider)?.number ??
      1;
  bool _invalid = false;
  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chapters = ref.watch(planChaptersProvider(PlanView.firstWeek));
    return HbPageScaffold(
      key: const ValueKey(AppRoute.noteNew),
      topBar: const HbPageHeader(fallback: AppRoute.notes),
      content: [
        DropdownButtonFormField<int>(
          initialValue: _chapter,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.menu_book),
            labelText: l10n.noteChooseChapter,
          ),
          isExpanded: true,
          items: [
            for (final chapter in chapters)
              DropdownMenuItem(
                value: chapter.number,
                child: Text(l10n.noteChapter(chapter.number, chapter.name)),
              ),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _chapter = value);
          },
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: NoteTokens.editorHeight),
          child: TextField(
            controller: _body,
            maxLines: null,
            style: NoteTokens.editor.copyWith(
              color: AppColors.of(context).text,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
              hintText: l10n.sessionNoteHint,
              errorText: _invalid ? l10n.noteRequired : null,
            ),
          ),
        ),
      ],
      actions: [
        const NotesPrivacy(short: true),
        HbButton(label: l10n.noteSave, onPressed: _save),
      ],
    );
  }

  void _save() {
    if (_body.text.trim().isEmpty) {
      setState(() => _invalid = true);
      return;
    }
    final chapter = ref
        .read(planChaptersProvider(PlanView.firstWeek))
        .where((value) => value.number == _chapter)
        .firstOrNull;
    if (chapter == null) return;
    ref
        .read(NoteController.provider.notifier)
        .save(
          _draft.copyWith(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            chapter: chapter.number,
            chapterName: chapter.name,
            body: _body.text,
            createdAt: DateTime.now(),
          ),
        );
    Navigator.of(context).pop();
  }
}
