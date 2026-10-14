import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_hero_tile.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';
import '../../../partners/logic/plan_witnesses.dart';
import '../../../today/logic/today_controller.dart';
import '../../domain/session_stage.dart';
import '../../logic/session_controller.dart';
import '../../logic/session_receipt_providers.dart';
import 'session_first_receipt.dart';
import 'session_next.dart';
import 'session_no_units.dart';
import 'session_units.dart';

class SessionReceipt extends ConsumerWidget {
  const SessionReceipt({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(SessionController.provider);
    if (state.isFirst) return const SessionFirstReceipt();
    if (state.stage == SessionStage.noUnits) return const SessionNoUnits();
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.sessionSaved),
      topBar: HbPageHeader(
        onBack: ref.read(SessionController.provider.notifier).resume,
      ),
      content: [
        HbHeroTile(
          asset: 'assets/icons/daily_check.svg',
          color: colors.green,
          fill: colors.greenSoft,
        ),
        HbHeading(
          title: l10n.sessionSavedTitle,
          description: l10n.sessionSavedBody,
        ),
        const SessionUnits(),
        _receipt(context, ref),
        SessionNext(chapter: ref.watch(sessionNextChapterProvider)),
      ],
      actions: [
        HbButton(
          label: l10n.sessionDone,
          onPressed: () {
            ref.read(SessionController.provider.notifier).save();
            ref
                .read(TodayController.provider.notifier)
                .sessionSaved(units: state.units, first: false);
            context.goNamed(AppRoute.today.name);
          },
        ),
      ],
    );
  }

  Widget _receipt(BuildContext context, WidgetRef ref) {
    final state = ref.watch(SessionController.provider);
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(Tokens.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Tokens.space12,
          children: [
            Text(
              l10n.sessionStudied(
                state.elapsedSeconds ~/ 60,
                state.elapsedSeconds % 60,
              ),
              style: Tokens.strong,
            ),
            Text(
              _privacy(ref, l10n, state.planId),
              style: Tokens.body.copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }

  String _privacy(WidgetRef ref, AppLocalizations l10n, String planId) {
    final witnesses = ref.watch(planWitnessesProvider(planId));
    if (witnesses.isEmpty) return l10n.sessionReceiptPrivate;
    return l10n.sessionReceiptPrivacy(
      witnesses.map((peer) => peer.name).join(', '),
    );
  }
}
