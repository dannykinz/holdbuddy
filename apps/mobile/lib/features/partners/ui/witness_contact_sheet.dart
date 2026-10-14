import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_field.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../../auth/domain/auth_validation.dart';
import '../../today/domain/today_view.dart';
import '../../today/logic/today_controller.dart';
import '../logic/people_controller.dart';
import '../logic/people_failure.dart';

class WitnessContactSheet extends ConsumerStatefulWidget {
  const WitnessContactSheet({super.key, this.editing = false});
  final bool editing;
  @override
  ConsumerState<WitnessContactSheet> createState() =>
      _WitnessContactSheetState();
}

class _WitnessContactSheetState extends ConsumerState<WitnessContactSheet> {
  final _name = TextEditingController();
  final _contact = TextEditingController();
  bool _invalid = false;
  @override
  void initState() {
    super.initState();
    if (!widget.editing) return;
    final peer = ref.read(selectedPeerProvider);
    _name.text = peer.name;
    _contact.text = peer.contact;
  }

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space20,
      children: [
        HbField(label: l.witnessContactName, controller: _name),
        HbField(
          label: l.witnessContactAddress,
          controller: _contact,
          errorText: _invalid ? l.witnessContactError : null,
          keyboardType: TextInputType.emailAddress,
        ),
        HbButton(label: l.witnessPrepare, onPressed: _save),
        if (ref.watch(PeopleFailure.provider)) Text(l.safetyError),
        HbPreviewNote(text: l.witnessContactPreview),
      ],
    );
  }

  void _save() {
    final name = AuthValidation.name(_name.text);
    final contact = _contact.text.trim();
    if (!AuthValidation.validName(name) || !_validContact(contact)) {
      setState(() => _invalid = true);
      return;
    }
    final controller = ref.read(PeopleController.provider.notifier);
    final saved = widget.editing
        ? controller.save(
            ref
                .read(selectedPeerProvider)
                .copyWith(name: name, contact: contact, pending: true),
          )
        : controller.invite(name, contact);
    if (!saved) return;
    Navigator.pop(context);
    unawaited(
      context.pushNamed<void>(
        ref.read(TodayController.provider) == TodayView.offline
            ? AppRoute.witnessOfflineInvite.name
            : AppRoute.witnessPending.name,
      ),
    );
  }

  bool _validContact(String value) {
    if (AuthValidation.validEmail(value)) return true;
    final compact = value.replaceAll(RegExp(r'[ ()-]'), '');
    return RegExp(r'^[+]?[0-9]{7,15}$').hasMatch(compact);
  }
}
