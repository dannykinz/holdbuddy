import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/router/navigation_error.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_notice.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';
import '../../../today/logic/today_controller.dart';
import '../../logic/session_controller.dart';
import '../../logic/session_receipt_providers.dart';
import 'session_units.dart';

class SessionNoUnits extends ConsumerWidget {
  const SessionNoUnits({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(SessionController.provider);
    final plan = ref.watch(sessionPlanProvider);
    if (plan == null) return const NavigationError();
    final data = ref
        .watch(todayRepositoryProvider)
        .overviewFor(plan, ref.watch(sessionNextChapterProvider), '');
    final l10n = AppLocalizations.of(context);
    return HbPageScaffold(
      topBar: HbPageHeader(
        onBack: () => ref.read(SessionController.provider.notifier).setUnits(1),
      ),
      content: [
        HbHeading(
          title: l10n.sessionNoUnitsTitle,
          description: l10n.sessionNoUnitsBody(
            state.elapsedSeconds ~/ 60,
            state.elapsedSeconds % 60,
          ),
        ),
        const SessionUnits(),
        HbNotice(
          title: l10n.sessionFinishUpdated,
          body: l10n.sessionNoUnitsFinish(
            DateFormat.MMMMd(l10n.localeName).format(data.missedFinishDate),
          ),
          iconSize: Tokens.space20,
        ),
      ],
      actions: [
        HbButton(
          label: l10n.sessionSaveContinue,
          onPressed: () {
            ref.read(SessionController.provider.notifier).save();
            ref
                .read(TodayController.provider.notifier)
                .sessionSaved(units: 0, first: false);
            context.goNamed(AppRoute.today.name);
          },
        ),
      ],
    );
  }
}
