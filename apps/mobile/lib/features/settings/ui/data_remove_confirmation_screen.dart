import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_notice.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';

class DataRemoveConfirmationScreen extends StatelessWidget {
  const DataRemoveConfirmationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.dataRemoveConfirmation),
      topBar: const HbPageHeader(fallback: AppRoute.privacyLocalData),
      content: [
        HbHeading(
          title: l10n.privacyRemoveTitle,
          description: l10n.privacyRemoveBody,
        ),
        HbNotice(
          iconSize: Tokens.space20,
          title: l10n.privacyNoCloud,
          body: l10n.privacyNoCloudBody,
          asset: 'assets/icons/privacy_remove_info.svg',
          destructive: true,
        ),
      ],
      actions: [
        HbButton(
          label: l10n.privacyRemove,
          variant: HbButtonVariant.secondary,
          destructive: true,
          onPressed: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.privacyRemovalPreview))),
        ),
        HbButton(label: l10n.privacyKeep, onPressed: () => context.pop()),
      ],
      footnote: Text(l10n.privacyRemovalPreview, textAlign: TextAlign.center),
    );
  }
}
