import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_hero_tile.dart';
import '../../../core/widgets/hb_info_list.dart';
import '../../../core/widgets/hb_result_screen.dart';
import '../../partners/logic/people_controller.dart';

class ReportSentScreen extends ConsumerWidget {
  const ReportSentScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final blocked = ref.watch(selectedPeerProvider).blocked;
    return HbResultScreen(
      title: l.safetyThanks,
      body: l.safetyReportPrepared,
      showBack: false,
      leading: HbHeroTile(
        asset: 'assets/icons/people_shield.svg',
        color: c.green,
        fill: c.greenSoft,
      ),
      details: [
        HbInfoList(
          checked: true,
          items: blocked
              ? [
                  l.safetyBlockedSummary,
                  l.safetyBlockedAccess,
                  l.safetyBlockedPrivacy,
                ]
              : [l.safetyReportOnly],
        ),
      ],
      actions: [
        HbButton(
          label: l.safetyBackPartners,
          onPressed: () => context.goNamed(AppRoute.partners.name),
        ),
      ],
    );
  }
}
