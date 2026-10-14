import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_field.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';
import '../../../../core/widgets/hb_preview_note.dart';
import '../../../auth/domain/auth_validation.dart';
import '../../domain/learner.dart';
import '../../logic/learner_providers.dart';
import '../../logic/profile_controller.dart';
import 'profile_photo.dart';

class ProfileForm extends ConsumerStatefulWidget {
  const ProfileForm({super.key, required this.learner});
  final Learner learner;
  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.learner.displayName);
  late final _email = TextEditingController(text: widget.learner.email);
  late final _studying = TextEditingController(text: widget.learner.studying);
  late String _avatar = widget.learner.avatar;
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _studying.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final save = ref.watch(ProfileController.provider);
    return Form(
      key: _form,
      child: HbPageScaffold(
        topBar: const HbPageHeader(fallback: AppRoute.settings),
        content: [
          ProfilePhoto(
            avatar: _avatar,
            name: _name.text,
            onChanged: (value) => setState(() => _avatar = value),
          ),
          ..._fields(context),
          TextButton(
            onPressed: () => context.pushNamed(AppRoute.accountDelete.name),
            child: Text(l.profileDelete),
          ),
          if (save.hasError) Text(l.profileSaveError),
        ],
        actions: [
          HbButton(
            label: l.profileSave,
            loading: save.isLoading,
            onPressed: save.isLoading ? null : _save,
          ),
        ],
        footnote: const HbPreviewNote(),
      ),
    );
  }

  List<Widget> _fields(BuildContext context) {
    final l = AppLocalizations.of(context);
    return [
      HbField(
        label: l.profileName,
        controller: _name,
        inputFormatters: [
          LengthLimitingTextInputFormatter(AuthValidation.maximumNameLength),
        ],
        validator: (value) => !AuthValidation.validName(value ?? '')
            ? l.profileInvalidName
            : null,
      ),
      HbField(
        label: l.profileEmail,
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        validator: (value) =>
            AuthValidation.validEmail(value ?? '') ? null : l.authEmailError,
      ),
      HbField(
        label: l.profileStudying,
        controller: _studying,
        inputFormatters: [LengthLimitingTextInputFormatter(200)],
        validator: (value) =>
            (value ?? '').trim().isEmpty ? l.profileInvalidStudying : null,
      ),
    ];
  }

  Future<void> _save() async {
    final form = _form.currentState;
    if (form == null || !form.validate()) return;
    final learner = widget.learner.copyWith(
      displayName: AuthValidation.name(_name.text),
      email: AuthValidation.email(_email.text),
      studying: _studying.text.trim(),
      avatar: _avatar,
    );
    final saved = await ref
        .read(ProfileController.provider.notifier)
        .save(learner);
    if (!mounted || !saved) return;
    context.goNamed(AppRoute.settings.name);
    ref.invalidate(learnerProvider);
  }
}
