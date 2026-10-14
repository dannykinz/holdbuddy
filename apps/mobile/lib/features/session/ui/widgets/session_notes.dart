import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_field.dart';
import '../../logic/session_controller.dart';

class SessionNotes extends ConsumerStatefulWidget {
  const SessionNotes({super.key});
  @override
  ConsumerState<SessionNotes> createState() => _SessionNotesState();
}

class _SessionNotesState extends ConsumerState<SessionNotes> {
  late final _notes = TextEditingController(
    text: ref.read(SessionController.provider).note,
  );
  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.listen(SessionController.provider.select((state) => state.isFirst), (
      previous,
      next,
    ) {
      _notes.text = ref.read(SessionController.provider).note;
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space12,
      children: [
        HbField(
          label: l10n.sessionYourNotes,
          controller: _notes,
          hintText: l10n.sessionNoteHint,
          maxLines: DailyTokens.notesLines,
          minimumHeight: DailyTokens.notesHeight,
          onChanged: ref.read(SessionController.provider.notifier).saveNote,
        ),
        Text(
          l10n.sessionNotesPrivacy,
          style: Tokens.small.copyWith(color: AppColors.of(context).muted),
        ),
      ],
    );
  }
}
