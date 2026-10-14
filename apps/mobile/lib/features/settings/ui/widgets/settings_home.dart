import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_tab_scaffold.dart';
import 'settings_account_card.dart';
import 'settings_feedback.dart';
import 'settings_links.dart';
import 'settings_pro_banner.dart';

class SettingsHome extends StatelessWidget {
  const SettingsHome({super.key});
  @override
  Widget build(BuildContext context) => HbTabScaffold(
    topBar: const HbPageHeader(),
    contentSpacing: Tokens.space20,
    children: [
      HbHeading(title: AppLocalizations.of(context).settingsTitle),
      const SettingsProBanner(),
      const SettingsAccountCard(),
      const SettingsLinks(),
      const SettingsFeedback(),
      HbButton(
        label: AppLocalizations.of(context).authSignOut,
        variant: HbButtonVariant.ghost,
        onPressed: () => context.pushNamed(AppRoute.signOutConfirm.name),
      ),
    ],
  );
}
