import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_hero_tile.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';
import '../../domain/plan_view.dart';
import '../../logic/plan_controller.dart';

class PlanLoadError extends ConsumerWidget {
  const PlanLoadError({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => HbPageScaffold(
    topBar: const HbPageHeader(),
    content: [
      HbHeroTile(
        asset: 'assets/icons/plan_error.svg',
        color: AppColors.of(context).green,
        fill: AppColors.of(context).greenSoft,
      ),
      HbHeading(
        title: AppLocalizations.of(context).planLoadErrorTitle,
        description: AppLocalizations.of(context).planLoadErrorBody,
      ),
    ],
    actions: [
      HbButton(
        label: AppLocalizations.of(context).tryAgain,
        onPressed: () =>
            ref.read(PlanController.provider.notifier).show(PlanView.path),
      ),
    ],
  );
}
