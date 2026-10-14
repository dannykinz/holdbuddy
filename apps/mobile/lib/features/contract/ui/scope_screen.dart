import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_field.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_step_header.dart';
import '../../today/domain/today_view.dart';
import '../../today/logic/today_controller.dart';
import '../logic/contract_controller.dart';
import 'widgets/scope_material_card.dart';

class ScopeScreen extends ConsumerStatefulWidget {
  const ScopeScreen({super.key});
  @override
  ConsumerState<ScopeScreen> createState() => _ScopeScreenState();
}

class _ScopeScreenState extends ConsumerState<ScopeScreen> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(
    text: ref.read(ContractController.provider).title,
  );
  late final _total = TextEditingController(
    text: ref.read(ContractController.provider).totalUnits.toString(),
  );
  late final _unitName = TextEditingController(
    text: ref.read(ContractController.provider).unitName,
  );
  bool _submitted = false;

  @override
  void dispose() {
    _title.dispose();
    _total.dispose();
    _unitName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(ContractController.provider);
    final invalid = _submitted && !draft.scopeValid;
    return Form(
      key: _form,
      autovalidateMode: _submitted
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: HbPageScaffold(
        key: const ValueKey(AppRoute.scope),
        topBar: HbStepHeader(
          step: 1,
          title: invalid ? l10n.contractScopeStep : null,
          fallback: AppRoute.getStarted,
          trailing: invalid
              ? null
              : TextButton(
                  onPressed: () {
                    ref
                        .read(TodayController.provider.notifier)
                        .show(TodayView.empty);
                    context.goNamed(AppRoute.today.name);
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(l10n.contractLater, style: Tokens.label),
                ),
        ),
        content: _content(invalid),
        actions: [
          HbButton(
            label: l10n.contractSetRhythm,
            onPressed: invalid ? null : _next,
          ),
        ],
      ),
    );
  }

  List<Widget> _content(bool invalid) {
    final l10n = AppLocalizations.of(context);
    return [
      HbHeading(
        title: invalid ? l10n.contractScopeInvalid : l10n.contractScopeBefore,
        accent: invalid ? '' : l10n.contractScopeAccent,
        after: invalid ? '' : l10n.contractScopeAfter,
        description: invalid ? null : l10n.contractScopeBody,
      ),
      HbField(
        label: l10n.contractLearning,
        controller: _title,
        labelStyle: AuthTokens.fieldLabel,
        onChanged: _save,
        validator: (value) =>
            (value ?? '').trim().isEmpty ? l10n.contractNameError : null,
      ),
      if (invalid && _unitName.text.trim().isNotEmpty)
        _totalField()
      else
        _units(),
      if (!invalid) const ScopeMaterialCard(),
    ];
  }

  Widget _units() => Row(
    spacing: ContractTokens.unitsGap,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(flex: ContractTokens.scopeUnitsFlex, child: _totalField()),
      Expanded(
        flex: ContractTokens.scopeNameFlex,
        child: HbField(
          label: AppLocalizations.of(context).contractUnitName,
          labelStyle: AuthTokens.fieldLabel,
          controller: _unitName,
          onChanged: _save,
          validator: (value) => (value ?? '').trim().isEmpty
              ? AppLocalizations.of(context).contractUnitError
              : null,
        ),
      ),
    ],
  );

  Widget _totalField() => HbField(
    label: _submitted && !ref.read(ContractController.provider).scopeValid
        ? AppLocalizations.of(context).contractTotalChapters
        : AppLocalizations.of(context).contractTotalUnits,
    labelStyle: AuthTokens.fieldLabel,
    controller: _total,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    onChanged: _save,
    validator: (value) => (int.tryParse(value ?? '') ?? 0) > 0
        ? null
        : AppLocalizations.of(context).contractWholeNumberError,
  );

  void _save(String _) {
    final notifier = ref.read(ContractController.provider.notifier);
    notifier.update(
      ref
          .read(ContractController.provider)
          .copyWith(
            title: _title.text.trim(),
            totalUnits: int.tryParse(_total.text) ?? 0,
            unitName: _unitName.text.trim(),
          ),
    );
  }

  void _next() {
    setState(() => _submitted = true);
    if (!(_form.currentState?.validate() ?? false)) return;
    if (!ref.read(ContractController.provider).scopeValid) return;
    FocusScope.of(context).unfocus();
    unawaited(context.pushNamed<void>(AppRoute.rhythm.name));
  }
}
