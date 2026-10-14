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

class LegalPrivacyScreen extends StatelessWidget {
  const LegalPrivacyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.legalPrivacy),
      topBar: const HbPageHeader(fallback: AppRoute.signUp),
      content: [
        HbHeading(title: l10n.legalTitle),
        Text(l10n.legalAccount, style: Tokens.body),
        Text(l10n.legalWitness, style: Tokens.body),
        HbNotice(
          iconSize: Tokens.space20,
          title: l10n.legalBeforeLaunch,
          body: l10n.legalReviewBody,
          asset: 'assets/icons/privacy_info.svg',
        ),
      ],
      actions: [
        HbButton(
          label: l10n.legalBackSignup,
          variant: HbButtonVariant.secondary,
          onPressed: () => context.goNamed(AppRoute.signUp.name),
        ),
      ],
    );
  }
}
