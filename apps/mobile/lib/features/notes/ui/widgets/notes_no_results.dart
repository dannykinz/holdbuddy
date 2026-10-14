import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_hero_tile.dart';

class NotesNoResults extends StatelessWidget {
  const NotesNoResults({super.key, required this.query, required this.onClear});
  final String query;
  final VoidCallback onClear;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space24,
      children: [
        HbHeroTile(
          asset: 'assets/icons/note_search.svg',
          color: colors.sky,
          fill: colors.skySoft,
          size: AuthTokens.heroSize,
          radius: AuthTokens.heroRadius,
        ),
        Text(l10n.notesNoMatch(query), style: Tokens.title),
        Text(
          l10n.notesNoMatchBody,
          style: Tokens.body.copyWith(color: colors.muted),
        ),
        HbButton(
          label: l10n.notesClear,
          variant: HbButtonVariant.secondary,
          onPressed: onClear,
        ),
      ],
    );
  }
}
