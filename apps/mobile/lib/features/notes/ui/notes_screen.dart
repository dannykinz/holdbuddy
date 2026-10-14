import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_tab_scaffold.dart';
import '../logic/note_controller.dart';
import '../logic/note_search.dart';
import 'widgets/note_list_card.dart';
import 'widgets/notes_empty.dart';
import 'widgets/notes_no_results.dart';
import 'widgets/notes_privacy.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});
  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(NoteController.provider);
    final notes = ref.watch(filteredNotesProvider);
    final l10n = AppLocalizations.of(context);
    if (all.isEmpty) return const NotesEmpty();
    return HbTabScaffold(
      key: const ValueKey(AppRoute.notes),
      footer: const NotesPrivacy(),
      children: [
        HbHeading(
          title: notes.isEmpty ? l10n.notesFindTitle : l10n.notesTitle,
          description: notes.isEmpty ? null : l10n.notesBody,
        ),
        TextField(
          controller: _search,
          decoration: InputDecoration(
            hintText: l10n.notesSearch,
            semanticCounterText: l10n.notesSearch,
          ),
          onChanged: ref.read(NoteSearch.provider.notifier).search,
        ),
        if (notes.isEmpty)
          NotesNoResults(query: _search.text, onClear: _clear)
        else
          Column(
            spacing: Tokens.space12,
            children: [
              for (var index = 0; index < notes.length; index++)
                NoteListCard(
                  note: notes[index],
                  onPressed: () => context.pushNamed(
                    AppRoute.noteDetail.name,
                    extra: notes[index].id,
                  ),
                ),
            ],
          ),
      ],
    );
  }

  void _clear() {
    _search.clear();
    ref.read(NoteSearch.provider.notifier).search('');
  }
}
