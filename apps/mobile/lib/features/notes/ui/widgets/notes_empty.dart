import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_hero_tile.dart';
import '../../../../core/widgets/hb_tab_scaffold.dart';

class NotesEmpty extends StatelessWidget {
  const NotesEmpty({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return HbTabScaffold(
      key: const ValueKey(AppRoute.notes),
      children: [
        HbHeroTile(
          asset: 'assets/icons/note_empty.svg',
          color: colors.purple,
          fill: colors.purpleSoft,
          size: AuthTokens.heroSize,
          radius: AuthTokens.heroRadius,
        ),
        HbHeading(
          title: l10n.emptyNotesHeading,
          description: l10n.emptyNotesDescription,
        ),
        Text(
          l10n.emptyNotesPrivacy,
          style: Tokens.body.copyWith(color: colors.muted),
        ),
        HbButton(
          label: l10n.notesGoToday,
          variant: HbButtonVariant.secondary,
          onPressed: () => context.goNamed(AppRoute.today.name),
        ),
      ],
    );
  }
}
