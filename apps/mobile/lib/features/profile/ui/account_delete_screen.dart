import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_field.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_info_list.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../logic/profile_controller.dart';

class AccountDeleteScreen extends ConsumerStatefulWidget {
  const AccountDeleteScreen({super.key});
  @override
  ConsumerState<AccountDeleteScreen> createState() =>
      _AccountDeleteScreenState();
}

class _AccountDeleteScreenState extends ConsumerState<AccountDeleteScreen> {
  final _confirm = TextEditingController();
  @override
  void dispose() {
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final save = ref.watch(ProfileController.provider);
    return HbPageScaffold(
      topBar: const HbPageHeader(fallback: AppRoute.profileEdit),
      content: [
        HbHeading(
          title: l.accountDeleteTitle,
          description: l.accountDeleteBody,
        ),
        HbInfoList(
          destructive: true,
          items: [
            l.accountDeleteProfile,
            l.accountDeletePlans,
            l.accountDeletePartners,
            l.accountDeleteDeadlines,
          ],
        ),
        HbField(
          label: l.accountDeleteConfirm,
          controller: _confirm,
          onChanged: (_) => setState(() {}),
        ),
        if (save.hasError) Text(l.profileSaveError),
      ],
      actions: [
        HbButton(
          label: l.accountDeleteAction,
          destructive: true,
          loading: save.isLoading,
          onPressed: _confirm.text == l.accountDeleteWord && !save.isLoading
              ? _delete
              : null,
        ),
        HbButton(
          label: l.accountKeep,
          variant: HbButtonVariant.ghost,
          onPressed: () => context.goNamed(AppRoute.profileEdit.name),
        ),
      ],
      footnote: HbPreviewNote(text: l.accountDeletePreview),
    );
  }

  Future<void> _delete() async {
    final saved = await ref
        .read(ProfileController.provider.notifier)
        .confirmDeletionPreview();
    if (!mounted || !saved) return;
    context.goNamed(AppRoute.accountDeleted.name);
  }
}
