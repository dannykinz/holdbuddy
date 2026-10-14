import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_field.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_notice.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_step_header.dart';
import '../logic/contract_controller.dart';

class ConsequenceScreen extends ConsumerStatefulWidget {
  const ConsequenceScreen({super.key});
  @override
  ConsumerState<ConsequenceScreen> createState() => _ConsequenceScreenState();
}

class _ConsequenceScreenState extends ConsumerState<ConsequenceScreen> {
  late final _message = TextEditingController(
    text: ref.read(ContractController.provider).message,
  );

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(ContractController.provider);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.consequence),
      topBar: const HbStepHeader(step: 3, fallback: AppRoute.rhythm),
      content: [
        HbHeading(
          title: l10n.contractConsequenceTitle,
          description: l10n.contractConsequenceBody,
        ),
        HbField(
          label: l10n.contractYourMessage,
          controller: _message,
          labelStyle: AuthTokens.fieldLabel,
          maxLines: ContractTokens.messageLines,
          minimumHeight: ContractTokens.messageHeight,
          onChanged: (value) => ref
              .read(ContractController.provider.notifier)
              .update(draft.copyWith(message: value.trim())),
        ),
        HbNotice(
          title: l10n.contractControlTitle,
          body: l10n.contractControlBody,
          iconSize: Tokens.space20,
        ),
      ],
      actions: [
        HbButton(
          label: l10n.contractChooseWitness,
          onPressed: draft.message.trim().isEmpty
              ? null
              : () => context.pushNamed(AppRoute.chooseWitness.name),
        ),
      ],
    );
  }
}
