import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_hero_tile.dart';
import '../../../core/widgets/hb_result_screen.dart';
import '../logic/plan_controller.dart';

class ArchiveSavedScreen extends ConsumerWidget {
  const ArchiveSavedScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = AppColors.of(context);
    return HbResultScreen(
      title: l.archiveSaved,
      body: l.archiveSavedBody(ref.watch(chosenPlanProvider).unitsDone),
      showBack: false,
      leading: HbHeroTile(
        asset: 'assets/icons/daily_book.svg',
        color: c.sky,
        fill: c.skySoft,
      ),
      actions: [
        HbButton(
          label: l.archiveReadNotes,
          variant: HbButtonVariant.secondary,
          onPressed: () => context.goNamed(AppRoute.notes.name),
        ),
        HbButton(
          label: l.archiveNew,
          onPressed: () => context.goNamed(AppRoute.scope.name),
        ),
      ],
    );
  }
}
