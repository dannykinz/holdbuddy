import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_hold_button.dart';
import '../../../core/widgets/hb_notice.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_step_header.dart';
import '../../today/logic/today_controller.dart';
import '../logic/contract_controller.dart';
import 'widgets/contract_summary.dart';

class ContractScreen extends ConsumerStatefulWidget {
  const ContractScreen({super.key});
  @override
  ConsumerState<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends ConsumerState<ContractScreen> {
  bool _holding = false;
  bool _commitFailed = false;
  int _attempt = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(ContractController.provider);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.contract),
      topBar: HbStepHeader(
        step: 4,
        fallback: AppRoute.chooseWitness,
        title: _holding ? l10n.contractYourContract : null,
      ),
      content: [
        HbHeading(
          title: l10n.contractPromiseBefore,
          accent: l10n.contractPromiseAccent,
          after: l10n.authHeadlineAfter,
        ),
        const ContractSummary(),
        if (_commitFailed)
          HbNotice(
            title: l10n.contractSaveError,
            body: l10n.contractSaveErrorBody,
          ),
        Text(
          l10n.contractRenegotiate,
          style: Tokens.small.copyWith(color: AppColors.of(context).muted),
        ),
      ],
      actions: [
        HbHoldButton(
          key: ValueKey(_attempt),
          label: l10n.contractHold,
          holdingLabel: l10n.contractHolding,
          enabled: draft.canCommit,
          onHoldingChanged: (holding) => setState(() => _holding = holding),
          onCommitted: _commit,
        ),
      ],
    );
  }

  void _commit() {
    if (!ref.read(ContractController.provider.notifier).commit()) {
      setState(() {
        _commitFailed = true;
        _holding = false;
        _attempt++;
      });
      return;
    }
    ref.read(TodayController.provider.notifier).planCommitted();
    context.goNamed(AppRoute.today.name);
  }
}
