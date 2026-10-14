import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_note_card.dart';
import '../../../material/logic/material_controller.dart';
import '../../../notes/logic/note_controller.dart';
import '../../../notes/ui/note_palette.dart';

class ChapterLinks extends ConsumerWidget {
  const ChapterLinks({super.key, required this.chapter});
  final int chapter;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final material = ref.watch(planMaterialsProvider).firstOrNull;
    final note = ref
        .watch(NoteController.provider)
        .where((note) => note.chapter == chapter)
        .firstOrNull;
    return Column(
      spacing: Tokens.space24,
      children: [
        if (material != null)
          HbNoteCard(
            width: null,
            title: l10n.sessionYourMaterial,
            body: l10n.sessionMaterialPage(material.name),
            fill: colors.soft,
            onPressed: () => context.pushNamed(AppRoute.materialLibrary.name),
          ),
        if (note != null)
          HbNoteCard(
            width: null,
            title: l10n.sessionYourNote,
            body: note.body,
            fill: note.category.colors(colors).soft,
            onPressed: () =>
                context.pushNamed(AppRoute.noteDetail.name, extra: note.id),
          ),
      ],
    );
  }
}
