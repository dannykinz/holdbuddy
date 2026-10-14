import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_field.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_notice.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_step_header.dart';
import '../../auth/domain/auth_validation.dart';
import '../logic/contract_controller.dart';

class ChooseWitnessScreen extends ConsumerStatefulWidget {
  const ChooseWitnessScreen({super.key});
  @override
  ConsumerState<ChooseWitnessScreen> createState() =>
      _ChooseWitnessScreenState();
}

class _ChooseWitnessScreenState extends ConsumerState<ChooseWitnessScreen> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(
    text: ref.read(ContractController.provider).witnessName,
  );
  late final _contact = TextEditingController(
    text: ref.read(ContractController.provider).witnessContact,
  );

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Form(
      key: _form,
      child: HbPageScaffold(
        key: const ValueKey(AppRoute.chooseWitness),
        topBar: const HbStepHeader(step: 4, fallback: AppRoute.consequence),
        content: [
          HbHeading(
            title: l10n.contractWitnessTitle,
            description: l10n.contractWitnessBody,
          ),
          HbField(
            label: l10n.contractTheirName,
            controller: _name,
            labelStyle: AuthTokens.fieldLabel,
            validator: (value) => AuthValidation.validName(value ?? '')
                ? null
                : l10n.authNameError,
          ),
          HbField(
            label: l10n.contractTheirContact,
            controller: _contact,
            labelStyle: AuthTokens.fieldLabel,
            keyboardType: TextInputType.emailAddress,
            validator: _validateContact,
          ),
          HbNotice(
            title: l10n.contractWitnessNotice,
            body: l10n.contractWitnessNoticeBody,
            iconSize: Tokens.space20,
          ),
        ],
        actions: [
          HbButton(label: l10n.contractReview, onPressed: () => _next(false)),
          HbButton(
            label: l10n.contractWithoutWitness,
            variant: HbButtonVariant.ghost,
            onPressed: () => _next(true),
          ),
        ],
      ),
    );
  }

  String? _validateContact(String? value) {
    final text = (value ?? '').trim();
    if (AuthValidation.validEmail(text)) return null;
    if (RegExp(r'^\+?[0-9][0-9 ()-]{6,}$').hasMatch(text)) return null;
    return AppLocalizations.of(context).contractContactError;
  }

  Future<void> _next(bool skip) async {
    if (!skip && !(_form.currentState?.validate() ?? false)) return;
    ref
        .read(ContractController.provider.notifier)
        .update(
          ref
              .read(ContractController.provider)
              .copyWith(
                witnessName: AuthValidation.name(_name.text),
                witnessContact: _contact.text.trim(),
                withoutWitness: skip,
              ),
        );
    FocusScope.of(context).unfocus();
    await context.pushNamed<void>(AppRoute.contract.name);
  }
}
