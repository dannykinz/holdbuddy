import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../logic/pro_controller.dart';
import 'pro_paywall_screen.dart';
import 'widgets/pro_hero.dart';

class ProWelcomeScreen extends ConsumerWidget {
  const ProWelcomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(ProController.provider).enabled)
      return const ProPaywallScreen();
    final l = AppLocalizations.of(context);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.proWelcome),
      topBar: const HbPageHeader(),
      gap: Tokens.space16,
      content: const [ProHero(welcome: true)],
      actions: [
        HbButton(
          label: l.proBackToday,
          onPressed: () => context.goNamed(AppRoute.today.name),
        ),
      ],
      footnote: HbPreviewNote(text: l.proWelcomePreview),
    );
  }
}
