import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_field.dart';
import '../../plan/logic/current_chapter.dart';
import '../logic/task_controller.dart';

class AddTaskSheet extends ConsumerStatefulWidget {
  const AddTaskSheet({super.key, this.chapter});
  final int? chapter;
  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {
  final _title = TextEditingController();
  bool _invalid = false;
  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space20,
      children: [
        HbField(
          label: l10n.taskTitle,
          controller: _title,
          hintText: l10n.taskHint,
          errorText: _invalid ? l10n.taskError : null,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _save(),
        ),
        HbButton(label: l10n.taskAddAction, onPressed: _save),
      ],
    );
  }

  void _save() {
    final chapter = widget.chapter ?? ref.read(currentChapterProvider)?.number;
    if (chapter == null) return;
    if (!ref
        .read(TaskController.provider.notifier)
        .add(_title.text, chapter: chapter)) {
      setState(() => _invalid = true);
      return;
    }
    Navigator.of(context).pop();
  }
}
